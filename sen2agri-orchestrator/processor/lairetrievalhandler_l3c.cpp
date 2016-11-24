#include <QJsonDocument>
#include <QJsonObject>
#include <QRegularExpression>
#include <fstream>

#include "lairetrievalhandler_l3c.hpp"
#include "processorhandlerhelper.h"
#include "json_conversions.hpp"
#include "logger.hpp"

// The number of tasks that are executed for each product before executing time series tasks
#define LAI_TASKS_PER_PRODUCT       6
#define MODEL_GEN_TASKS_PER_PRODUCT 4
#define CUT_TASKS_NO                5

#define DEFAULT_GENERATED_SAMPLES_NO    "40000"
#define DEFAULT_NOISE_VAR               "0.01"
#define DEFAULT_BEST_OF                 "1"
#define DEFAULT_REGRESSOR               "nn"

bool compareL3BProductDates(const QString& path1,const QString& path2)
{
    QFileInfo fileInfo1(path1);
    QString filename1(fileInfo1.fileName());
    QFileInfo fileInfo2(path2);
    QString filename2(fileInfo2.fileName());

    QDateTime minDate1, maxDate1;
    ProcessorHandlerHelper::GetHigLevelProductAcqDatesFromName(filename1, minDate1, maxDate1);
    QDateTime minDate2, maxDate2;
    ProcessorHandlerHelper::GetHigLevelProductAcqDatesFromName(filename2, minDate2, maxDate2);
    if(minDate1 == minDate2) {
        return QString::compare(filename1, filename2, Qt::CaseInsensitive);
    }
    return (minDate1 < minDate2);
}


void LaiRetrievalHandlerL3C::CreateTasksForNewProducts(QList<TaskToSubmit> &outAllTasksList,
                                                    LAIProductFormatterParams &outProdFormatterParams,
                                                    bool bNDayReproc, bool bFittedReproc, bool bRemoveTempFiles) {
    int initialTasksNo = outAllTasksList.size();
    // just create the tasks but with no information so far
    // first we add the tasks to be performed for each product
    outAllTasksList.append(TaskToSubmit{"lai-time-series-builder", {}});
    outAllTasksList.append(TaskToSubmit{"lai-err-time-series-builder", {}});
    outAllTasksList.append(TaskToSubmit{"lai-msk-flags-time-series-builder", {}});
    if(bNDayReproc) {
        outAllTasksList.append(TaskToSubmit{"lai-local-window-reprocessing", {}});
        outAllTasksList.append(TaskToSubmit{"lai-local-window-reproc-splitter", {}});
    } else if(bFittedReproc) {
        outAllTasksList.append(TaskToSubmit{"lai-fitted-reprocessing", {}});
        outAllTasksList.append(TaskToSubmit{"lai-fitted-reproc-splitter", {}});
    }
    if(bRemoveTempFiles) {
        outAllTasksList.append(TaskToSubmit{ "files-remover", {} });
    }


    // now fill the tasks hierarchy infos
    //              ---------------------------------------------------------------------------------
    //              |                              |                              |                 |
    //      time-series-builder         err-time-series-builder   lai-msk-flags-time-series-builder |
    //              |                              |                              |                 |
    //              ---------------------------------------------------------------------------------
    //                                  |
    //              ---------------------------------------------
    //              |                                           |
    //      profile-reprocessing                fitted-profile-reprocessing
    //              |                                           |
    //      reprocessed-profile-splitter        fitted-reprocessed-profile-splitter
    //              |                                           |
    //              ---------------------------------------------
    //                                  |
    //                          product-formatter
    //
    // Specifies if the products creation should be chained or not.
    // TODO: This should be taken from the configuration
    bool bChainProducts = true;

    int nCurTaskIdx = initialTasksNo;
    int nTimeSeriesBuilderIdx = nCurTaskIdx++;
    int nErrTimeSeriesBuilderIdx = nCurTaskIdx++;
    int nLaiMskFlgsTimeSeriesBuilderIdx = nCurTaskIdx++;

    // if we chain this product from another product
    if(bChainProducts && initialTasksNo > 0) {
        int prevProductLastTaskIdx = initialTasksNo-1;
        // we create a dependency to the last task of the previous product
        outAllTasksList[nTimeSeriesBuilderIdx].parentTasks.append(outAllTasksList[prevProductLastTaskIdx]);
        outAllTasksList[nErrTimeSeriesBuilderIdx].parentTasks.append(outAllTasksList[prevProductLastTaskIdx]);
        outAllTasksList[nLaiMskFlgsTimeSeriesBuilderIdx].parentTasks.append(outAllTasksList[prevProductLastTaskIdx]);
    }

    //profile-reprocessing -> time-series-builder AND err-time-series-builder AND lai-msk-flags-time-series-builder
    int nProfileReprocessingIdx = nCurTaskIdx++;
    outAllTasksList[nProfileReprocessingIdx].parentTasks.append(outAllTasksList[nTimeSeriesBuilderIdx]);
    outAllTasksList[nProfileReprocessingIdx].parentTasks.append(outAllTasksList[nErrTimeSeriesBuilderIdx]);
    outAllTasksList[nProfileReprocessingIdx].parentTasks.append(outAllTasksList[nLaiMskFlgsTimeSeriesBuilderIdx]);

    //reprocessed-profile-splitter -> profile-reprocessing
    int nReprocessedProfileSplitterIdx = nCurTaskIdx++;
    outAllTasksList[nReprocessedProfileSplitterIdx].parentTasks.append(outAllTasksList[nProfileReprocessingIdx]);

    //product-formatter -> reprocessed-profile-splitter
    outProdFormatterParams.laiReprocParams.parentsTasksRef.append(outAllTasksList[nReprocessedProfileSplitterIdx]);

    if(bRemoveTempFiles) {
        // cleanup-intermediate-files -> reprocessed-profile-splitter
        outAllTasksList[nCurTaskIdx].parentTasks.append(outAllTasksList[nReprocessedProfileSplitterIdx]);
    }
}

NewStepList LaiRetrievalHandlerL3C::GetStepsForMultiDateReprocessing(std::map<QString, QString> &configParameters,
                const TileTemporalFilesInfo &tileTemporalFilesInfo, QList<TaskToSubmit> &allTasksList,
                bool bNDayReproc, bool bFittedReproc, LAIProductFormatterParams &productFormatterParams,
               int tasksStartIdx, bool bRemoveTempFiles)
{
    NewStepList steps;
    QString reprocFileListFileName;
    QString reprocFlagsFileListFileName;
    QStringList cleanupTemporaryFilesList;

    QStringList monoDateMskFlagsLaiFileNames2;
    QStringList quantifiedLaiFileNames2;
    QStringList quantifiedErrLaiFileNames2;
    QString mainLaiImg;
    QString mainLaiErrImg;
    QString mainMsksImg;
    for(int i = 0; i< tileTemporalFilesInfo.temporalTilesFileInfos.size(); i++) {
        quantifiedLaiFileNames2.append(tileTemporalFilesInfo.temporalTilesFileInfos[i].additionalFiles[0]);
        quantifiedErrLaiFileNames2.append(tileTemporalFilesInfo.temporalTilesFileInfos[i].additionalFiles[1]);
        monoDateMskFlagsLaiFileNames2.append(tileTemporalFilesInfo.temporalTilesFileInfos[i].additionalFiles[2]);

        if(tileTemporalFilesInfo.temporalTilesFileInfos[i].satId == tileTemporalFilesInfo.primarySatelliteId) {
            if(mainLaiImg.length() == 0) {
                mainLaiImg = tileTemporalFilesInfo.temporalTilesFileInfos[i].additionalFiles[0];
                mainLaiErrImg = tileTemporalFilesInfo.temporalTilesFileInfos[i].additionalFiles[1];
                mainMsksImg = tileTemporalFilesInfo.temporalTilesFileInfos[i].additionalFiles[2];
            }
        }
    }

    int curTaskIdx = tasksStartIdx;
    TaskToSubmit &imgTimeSeriesBuilderTask = allTasksList[curTaskIdx++];
    TaskToSubmit &errTimeSeriesBuilderTask = allTasksList[curTaskIdx++];
    TaskToSubmit &mskFlagsTimeSeriesBuilderTask = allTasksList[curTaskIdx++];

    const auto & allLaiTimeSeriesFileName = imgTimeSeriesBuilderTask.GetFilePath("LAI_time_series.tif");
    const auto & allErrTimeSeriesFileName = errTimeSeriesBuilderTask.GetFilePath("Err_time_series.tif");
    const auto & allMskFlagsTimeSeriesFileName = mskFlagsTimeSeriesBuilderTask.GetFilePath("Mask_Flags_time_series.tif");

    QStringList timeSeriesBuilderArgs = GetTimeSeriesBuilderArgs(quantifiedLaiFileNames2, allLaiTimeSeriesFileName, mainLaiImg);
    QStringList errTimeSeriesBuilderArgs = GetErrTimeSeriesBuilderArgs(quantifiedErrLaiFileNames2, allErrTimeSeriesFileName, mainLaiErrImg);
    QStringList mskFlagsTimeSeriesBuilderArgs = GetMskFlagsTimeSeriesBuilderArgs(monoDateMskFlagsLaiFileNames2, allMskFlagsTimeSeriesFileName, mainMsksImg);

    steps.append(imgTimeSeriesBuilderTask.CreateStep("TimeSeriesBuilder", timeSeriesBuilderArgs));
    steps.append(errTimeSeriesBuilderTask.CreateStep("TimeSeriesBuilder", errTimeSeriesBuilderArgs));
    steps.append(mskFlagsTimeSeriesBuilderTask.CreateStep("TimeSeriesBuilder", mskFlagsTimeSeriesBuilderArgs));

    const QStringList &listDates = ProcessorHandlerHelper::GetTemporalTileAcquisitionDates(tileTemporalFilesInfo);

    TaskToSubmit &profileReprocTask = allTasksList[curTaskIdx++];
    TaskToSubmit &profileReprocSplitTask = allTasksList[curTaskIdx++];

    const auto & reprocTimeSeriesFileName = profileReprocTask.GetFilePath("ReprocessedTimeSeries.tif");
    reprocFileListFileName = profileReprocSplitTask.GetFilePath("ReprocessedFilesList.txt");
    reprocFlagsFileListFileName = profileReprocSplitTask.GetFilePath("ReprocessedFlagsFilesList.txt");

    QStringList profileReprocessingArgs;
    if(bNDayReproc) {
        profileReprocessingArgs = GetProfileReprocessingArgs(configParameters, allLaiTimeSeriesFileName,
                                                                         allErrTimeSeriesFileName, allMskFlagsTimeSeriesFileName,
                                                                         reprocTimeSeriesFileName, listDates);
    } else if(bFittedReproc) {
        profileReprocessingArgs = GetFittedProfileReprocArgs(allLaiTimeSeriesFileName,
                                                             allErrTimeSeriesFileName, allMskFlagsTimeSeriesFileName,
                                                             reprocTimeSeriesFileName, listDates);
    }
    QStringList reprocProfileSplitterArgs = GetReprocProfileSplitterArgs(reprocTimeSeriesFileName, reprocFileListFileName,
                                                                         reprocFlagsFileListFileName, listDates);
    steps.append(profileReprocTask.CreateStep("ProfileReprocessing", profileReprocessingArgs));
    steps.append(profileReprocSplitTask.CreateStep("ReprocessedProfileSplitter2", reprocProfileSplitterArgs));

    if(bRemoveTempFiles) {
        TaskToSubmit &cleanupTemporaryFilesTask = allTasksList[curTaskIdx++];
        cleanupTemporaryFilesList.append(allLaiTimeSeriesFileName);
        cleanupTemporaryFilesList.append(allErrTimeSeriesFileName);
        cleanupTemporaryFilesList.append(allMskFlagsTimeSeriesFileName);
        cleanupTemporaryFilesList.append(reprocTimeSeriesFileName);
        // add also the cleanup step
        steps.append(cleanupTemporaryFilesTask.CreateStep("CleanupTemporaryFiles", cleanupTemporaryFilesList));
    }

    productFormatterParams.laiReprocParams.fileLaiReproc = reprocFileListFileName;
    productFormatterParams.laiReprocParams.fileLaiReprocFlgs = reprocFlagsFileListFileName;

    return steps;
}

void LaiRetrievalHandlerL3C::HandleNewTilesList(EventProcessingContext &ctx, const JobSubmittedEvent &event,
                                             const TileTemporalFilesInfo &tileTemporalFilesInfo,
                                             LAIGlobalExecutionInfos &outGlobalExecInfos, bool bRemoveTempFiles) {

    const QJsonObject &parameters = QJsonDocument::fromJson(event.parametersJson.toUtf8()).object();
    std::map<QString, QString> configParameters = ctx.GetJobConfigurationParameters(event.jobId, "processor.l3b.");

    bool bNDayReproc = IsNDayReproc(parameters, configParameters);
    bool bFittedReproc = IsFittedReproc(parameters, configParameters);

    QList<TaskToSubmit> &allTasksList = outGlobalExecInfos.allTasksList;
    LAIProductFormatterParams &productFormatterParams = outGlobalExecInfos.prodFormatParams;

    int tasksStartIdx = allTasksList.size();

    // create the tasks
    CreateTasksForNewProducts(allTasksList, outGlobalExecInfos.prodFormatParams,
                              bNDayReproc, bFittedReproc, bRemoveTempFiles);

    QList<std::reference_wrapper<TaskToSubmit>> allTasksListRef;
    for(TaskToSubmit &task: allTasksList) {
        allTasksListRef.append(task);
    }
    // submit all tasks
    SubmitTasks(ctx, event.jobId, allTasksListRef);

    NewStepList &steps = outGlobalExecInfos.allStepsList;

    steps += GetStepsForMultiDateReprocessing(configParameters, tileTemporalFilesInfo, allTasksList,
                                              bNDayReproc, bFittedReproc, productFormatterParams,
                                              tasksStartIdx, bRemoveTempFiles);
}

void LaiRetrievalHandlerL3C::WriteExecutionInfosFile(const QString &executionInfosPath,
                                               std::map<QString, QString> &configParameters,
                                               const QStringList &listProducts, bool bIsReproc) {
    std::ofstream executionInfosFile;
    try
    {
        executionInfosFile.open(executionInfosPath.toStdString().c_str(), std::ofstream::out);
        executionInfosFile << "<?xml version=\"1.0\" ?>" << std::endl;
        executionInfosFile << "<metadata>" << std::endl;
        executionInfosFile << "  <General>" << std::endl;
        executionInfosFile << "  </General>" << std::endl;

        if(bIsReproc) {
            // Get the parameters from the configuration
            const auto &bwr = configParameters["processor.l3b.lai.localwnd.bwr"];
            const auto &fwr = configParameters["processor.l3b.lai.localwnd.fwr"];
            executionInfosFile << "  <ProfileReprocessing_parameters>" << std::endl;
            executionInfosFile << "    <bwr_for_algo_local_online_retrieval>" << bwr.toStdString() << "</bwr_for_algo_local_online_retrieval>" << std::endl;
            executionInfosFile << "    <fwr_for_algo_local_online_retrieval>"<< fwr.toStdString() <<"</fwr_for_algo_local_online_retrieval>" << std::endl;
            executionInfosFile << "  </ProfileReprocessing_parameters>" << std::endl;
        }
        executionInfosFile << "  <XML_files>" << std::endl;
        for (int i = 0; i<listProducts.size(); i++) {
            executionInfosFile << "    <XML_" << std::to_string(i) << ">" << listProducts[i].toStdString()
                               << "</XML_" << std::to_string(i) << ">" << std::endl;
        }
        executionInfosFile << "  </XML_files>" << std::endl;
        executionInfosFile << "</metadata>" << std::endl;
        executionInfosFile.close();
    }
    catch(...)
    {

    }
}

bool LaiRetrievalHandlerL3C::GetL2AProductsInterval(const QMap<QString, QStringList> &mapTilesMeta,
                                                    QDateTime &startDate, QDateTime &endDate) {
    bool bDatesInitialized = false;
    for(QString prd: mapTilesMeta.keys()) {
        const QStringList &listFiles = mapTilesMeta.value(prd);
        if(listFiles.size() > 0) {
            const QString &tileMeta = listFiles.at(0);
            QDateTime dtPrdDate = ProcessorHandlerHelper::GetL2AProductDateFromPath(tileMeta);
            if(!bDatesInitialized) {
                startDate = dtPrdDate;
                endDate = dtPrdDate;
                bDatesInitialized = true;
            } else {
                if(startDate > dtPrdDate) {
                    startDate = dtPrdDate;
                }
                if(endDate < dtPrdDate) {
                    endDate = dtPrdDate;
                }
            }
        }

    }
    return (bDatesInitialized && startDate.isValid() && endDate.isValid());
}

/**
 * Get all L3B products from the beginning of the season until now
 */
//TODO: This function should receive the Product and QList<Product> instead of just product path as these can be got from DB
//      The Product contains already the tiles, the full path and the acquisition date so can be avoided parsing files
QStringList LaiRetrievalHandlerL3C::GetL3BProducts(EventProcessingContext &ctx, int siteId)
{
    // extract the start and end dates
    QDateTime currentDateTime = QDateTime::currentDateTime();
    // Get all products from the last year (this might be needed in LAI FITTED)
    QDateTime startDateTime = currentDateTime.addMonths(-12);

    const ProductList &prdsList = ctx.GetProducts(siteId, (int)ProductType::L3BProductTypeId, startDateTime, currentDateTime);
    QStringList retList;
    for(const Product &prd: prdsList) {
        retList.append(prd.fullPath);
    }

    // sort ascending the list according to the acquisition time and the name if dates equal
    qSort(retList.begin(), retList.end(), compareL3BProductDates);

    return retList;
}

/**
 * Get the L3B products from the received event. If the input products are L2A then the associated L3B products are
 * search and returned
 */
//TODO: This function should receive the Product and QList<Product> instead of just product path as these can be got from DB
//      The Product contains already the tiles, the full path and the acquisition date so can be avoided parsing files
QStringList LaiRetrievalHandlerL3C::GetL3BProducts(EventProcessingContext &ctx, const JobSubmittedEvent &event)
{
    const auto &parameters = QJsonDocument::fromJson(event.parametersJson.toUtf8()).object();
    bool inputsAreL3b = (GetIntParameterValue(parameters, "inputs_are_l3b", 0) == 1);

    QStringList filteredL3bProductList;
    if(inputsAreL3b) {
        // fill the l3bMapTiles from the input L3B products
        const auto &inputProducts = parameters["input_products"].toArray();
        for (const auto &inputProduct : inputProducts) {
            filteredL3bProductList.append(ctx.GetProductAbsolutePath(inputProduct.toString()));
        }
    } else {
        QMap<QString, QStringList> inputProductToTilesMap;
        QStringList listTilesMetaFiles = GetL2AInputProductsTiles(ctx, event, inputProductToTilesMap);

        // get the L3B products for the current product tiles
        QDateTime startDate;
        QDateTime endDate;
        if(GetL2AProductsInterval(inputProductToTilesMap, startDate, endDate)) {
            // we consider the end date until the end of day
            endDate = endDate.addSecs(SECONDS_IN_DAY-1);
            ProductList l3bProductList = ctx.GetProducts(event.siteId, (int)ProductType::L3BProductTypeId, startDate, endDate);
            for(Product l3bPrd: l3bProductList) {
                // now filter again the products according to the
                for(const QString &l2aTileFile: listTilesMetaFiles) {
                    if(ProcessorHandlerHelper::HighLevelPrdHasL2aSource(l3bPrd.fullPath, l2aTileFile)) {
                        if(!filteredL3bProductList.contains(l3bPrd.fullPath)) {
                            filteredL3bProductList.append(l3bPrd.fullPath);
                        }
                    }
                }
            }
        }
    }

    return filteredL3bProductList;
}

//TODO: This function should receive the Product and QList<Product> instead of just product path as these can be got from DB
//      The Product contains already the tiles, the full path and the acquisition date so can be avoided parsing files
QMap<QString, TileTemporalFilesInfo> LaiRetrievalHandlerL3C::GetL3BMapTiles(EventProcessingContext &ctx, const QString &newestL3BProd,
                                                                            const QStringList &l3bProducts,
                                                                            const QMap<ProcessorHandlerHelper::SatelliteIdType, TileList> &siteTiles,
                                                                            int limitL3BPrdsPerTile)
{
    QMap<QString, TileTemporalFilesInfo> retL3bMapTiles;
    const QStringList &listNewestL3BProdTiles = ProcessorHandlerHelper::GetTileIdsFromHighLevelProduct(newestL3BProd);

    QDateTime minDate, maxDate;
    ProcessorHandlerHelper::GetHigLevelProductAcqDatesFromName(newestL3BProd, minDate, maxDate);
    ProcessorHandlerHelper::SatelliteIdType tileSatId = ProcessorHandlerHelper::SATELLITE_ID_TYPE_UNKNOWN;

    // iterate the tiles of the newest L3B product
    for(const auto &tileId : listNewestL3BProdTiles) {
        // we assume that all the tiles from the product are from the same satellite
        // in this case, we get only once the satellite Id for all tiles
        if(tileSatId == ProcessorHandlerHelper::SATELLITE_ID_TYPE_UNKNOWN) {
            tileSatId = GetSatIdForTile(siteTiles, tileId);
            // ignore tiles for which the satellite id cannot be determined
            if(tileSatId == ProcessorHandlerHelper::SATELLITE_ID_TYPE_UNKNOWN) {
                continue;
            }
        }

        // add the new tile info if missing
        if(!retL3bMapTiles.contains(tileId)) {
            TileTemporalFilesInfo newTileInfos;
            newTileInfos.tileId = tileId;
            newTileInfos.primarySatelliteId = tileSatId;
            newTileInfos.uniqueSatteliteIds.append(tileSatId);

            // Fill the tile information for the current tile from the current product
            AddTileFileInfo(ctx, newTileInfos, newestL3BProd, tileId, siteTiles, tileSatId, minDate);

            // add the tile infos to the map
            retL3bMapTiles[tileId] = newTileInfos;
        }
        TileTemporalFilesInfo &tileInfo = retL3bMapTiles[tileId];
        // NOTE: we assume the products are sorted ascending
        for(int i = l3bProducts.size(); i --> 0; ) {
            const QString &l3bPrd = l3bProducts[i];
            // If we have a limit of maximum temporal products per tile and we reached this limit,
            // then ignore the other products for this tile
            if(HasSufficientProducts(tileInfo, tileSatId, limitL3BPrdsPerTile)) {
                break;
            }

            // check if the current product date is greater than the one of the reference product
            // if so, ignore it
            QDateTime curPrdMinDate, curPrdMaxDate;
            ProcessorHandlerHelper::GetHigLevelProductAcqDatesFromName(l3bPrd, curPrdMinDate, curPrdMaxDate);
            if(curPrdMinDate.date() >= minDate.date()) {
                continue;
            }
            // Fill the tile information for the current tile from the current product
            AddTileFileInfo(ctx, tileInfo, l3bPrd, tileId, siteTiles, tileSatId, curPrdMinDate);
        }

        if(tileInfo.temporalTilesFileInfos.size() > 0) {
             // update the primary satellite information
             tileInfo.primarySatelliteId = ProcessorHandlerHelper::GetPrimarySatelliteId(tileInfo.uniqueSatteliteIds);
        }
    }
    return retL3bMapTiles;
}

bool LaiRetrievalHandlerL3C::AddTileFileInfo(EventProcessingContext &ctx, TileTemporalFilesInfo &temporalTileInfo, const QString &l3bPrd, const QString &tileId,
                                             const QMap<ProcessorHandlerHelper::SatelliteIdType, TileList> &siteTiles,
                                             ProcessorHandlerHelper::SatelliteIdType satId, const QDateTime &curPrdMinDate)
{
    // Fill the tile information for the current tile from the current product
    QMap<QString, QString> mapL3BTiles = ProcessorHandlerHelper::GetHighLevelProductTilesDirs(l3bPrd);
    if(mapL3BTiles.size() == 0) {
        return false;
    }
    const QString &tileDir = mapL3BTiles[tileId];
    if(tileDir.length() == 0) {
        // get the primary satellite from the received tile and the received product
        ProcessorHandlerHelper::SatelliteIdType l3bPrdSatId = GetSatIdForTile(siteTiles, mapL3BTiles.keys().at(0));
        QList<ProcessorHandlerHelper::SatelliteIdType> listSatIds = {satId, l3bPrdSatId};
        ProcessorHandlerHelper::SatelliteIdType primarySatId = ProcessorHandlerHelper::GetPrimarySatelliteId(listSatIds);
        // if is primary satellite only, then add intersecting tiles from the product
        // otherwise, if secondary satellite, then use only products of its own type (with the same tile)
        if(primarySatId == satId) {
            // get the tiles for satellite l3bPrdSatId that intersect tileId
            const TileList &allIntersectingTiles = ctx.GetIntersectingTiles(static_cast<Satellite>(satId), tileId);

            bool bAdded = false;
            // filter and add the secondary satellite tiles
            for(const QString &tileL3bPrd: mapL3BTiles.keys()) {
                for(const Tile &intersectingTile : allIntersectingTiles) {
                    if(((int)intersectingTile.satellite != (int)satId) && (intersectingTile.tileId  == tileL3bPrd)) {
                        const QString &newTileDir = mapL3BTiles[tileL3bPrd];
                        // this should not happen but is better to check
                        if(newTileDir.length() > 0) {
                            AddTileFileInfo(temporalTileInfo, l3bPrd, newTileDir, l3bPrdSatId, curPrdMinDate);
                            bAdded = true;
                        }
                    }
                }
            }
            return bAdded;
        } else {
            // if the satellite id of the tile is secondary compared with the l3bPrd received, then we do nothing
            return false;
        }
    }

    return AddTileFileInfo(temporalTileInfo, l3bPrd, tileDir, satId, curPrdMinDate);
}

bool LaiRetrievalHandlerL3C::AddTileFileInfo(TileTemporalFilesInfo &temporalTileInfo, const QString &l3bProdDir, const QString &l3bTileDir,
                                             ProcessorHandlerHelper::SatelliteIdType satId, const QDateTime &curPrdMinDate)
{
    if(l3bTileDir.length() > 0) {
        // fill the empty gaps for these lists
        ProcessorHandlerHelper::InfoTileFile l3bTileInfo;
        //update the sat id
        l3bTileInfo.satId = satId;
        // update the files
        // Set the file to the tile dir
        l3bTileInfo.file = ProcessorHandlerHelper::GetSourceL2AFromHighLevelProductIppFile(l3bProdDir);
        l3bTileInfo.acquisitionDate = curPrdMinDate.toString("yyyyMMdd");
        l3bTileInfo.additionalFiles.append(ProcessorHandlerHelper::GetHigLevelProductTileFile(l3bTileDir, "SLAIMONO"));
        l3bTileInfo.additionalFiles.append(ProcessorHandlerHelper::GetHigLevelProductTileFile(l3bTileDir, "MLAIERR", true));
        l3bTileInfo.additionalFiles.append(ProcessorHandlerHelper::GetHigLevelProductTileFile(l3bTileDir, "MMONODFLG", true));
        // add the sat id to the list of unique sat ids
        if(!temporalTileInfo.uniqueSatteliteIds.contains(l3bTileInfo.satId)) {
             temporalTileInfo.uniqueSatteliteIds.append(l3bTileInfo.satId);
        }
        //add it to the temporal tile files info
        temporalTileInfo.temporalTilesFileInfos.append(l3bTileInfo);
        return true;
    }
    return false;
}

bool LaiRetrievalHandlerL3C::HasSufficientProducts(const TileTemporalFilesInfo &tileInfo,
                                                   const ProcessorHandlerHelper::SatelliteIdType &tileSatId,
                                                   int limitL3BPrdsPerTile)
{
    // TODO: Should we consider here also the orbit???
    if(limitL3BPrdsPerTile > 0) {
        int cntSameSat = 0;
        // We must have at least limitL3BPrdsPerTile for the primary satellite
        // As we do not add in the temp info file the intersecting tiles of the same satellite
        // it is OK to count the occurences of the tile infos having the main satellite
        // as this means it is the same tile ID
        for(const ProcessorHandlerHelper::InfoTileFile &tempInfoFile: tileInfo.temporalTilesFileInfos) {
            if(tempInfoFile.satId == tileSatId) {
                cntSameSat++;
                if(cntSameSat > limitL3BPrdsPerTile) {
                    return true;
                }
            }
        }
    }
    return false;
}

void LaiRetrievalHandlerL3C::SubmitEndOfLaiTask(EventProcessingContext &ctx,
                                                const JobSubmittedEvent &event,
                                                const QList<TaskToSubmit> &allTasksList) {
    // add the end of lai job that will perform the cleanup
    QList<std::reference_wrapper<const TaskToSubmit>> prdFormatterTasksListRef;
    for(const TaskToSubmit &task: allTasksList) {
        if((task.moduleName == "lai-reproc-product-formatter") ||
                (task.moduleName == "lai-fitted-product-formatter")) {
            prdFormatterTasksListRef.append(task);
        }
    }
    // we add a task in order to wait for all product formatter to finish.
    // This will allow us to mark the job as finished and to remove the job folder
    TaskToSubmit endOfJobDummyTask{"lai-reproc-end-of-job", {}};
    endOfJobDummyTask.parentTasks.append(prdFormatterTasksListRef);
    SubmitTasks(ctx, event.jobId, {endOfJobDummyTask});
    ctx.SubmitSteps({endOfJobDummyTask.CreateStep("EndOfLAIDummy", QStringList())});
}

void LaiRetrievalHandlerL3C::HandleJobSubmittedImpl(EventProcessingContext &ctx,
                                             const JobSubmittedEvent &event)
{
    const auto &parameters = QJsonDocument::fromJson(event.parametersJson.toUtf8()).object();
    std::map<QString, QString> configParameters = ctx.GetJobConfigurationParameters(event.jobId, "processor.l3b.");

    bool bNDayReproc = IsNDayReproc(parameters, configParameters);
    bool bFittedReproc = IsFittedReproc(parameters, configParameters);
    if(!bNDayReproc && !bFittedReproc) {
        ctx.MarkJobFailed(event.jobId);
        throw std::runtime_error(
            QStringLiteral("Only one processing needs to be defined ("
                           " LAI N-reprocessing or LAI Fitted)").toStdString());
    }

    bool bRemoveTempFiles = NeedRemoveJobFolder(ctx, event.jobId, "l3b");

    int limitL3BPrdsPerTile = GetIntParameterValue(parameters, "max_l3b_per_tile", -1);
    // get the list of the L3B products from the event
    const QStringList &listL3BProducts = GetL3BProducts(ctx, event);
    // get all the L3B products to be used for extraction of previous products
    const QStringList &allL3BProductsList = GetL3BProducts(ctx, event.siteId);
    //container for all task
    QList<TaskToSubmit> allTasksList;

    const QMap<ProcessorHandlerHelper::SatelliteIdType, TileList> &siteTiles = GetSiteTiles(ctx, event.siteId);

    for(const QString &l3bProd: listL3BProducts) {
        const QMap<QString, TileTemporalFilesInfo> &l3bMapTiles = GetL3BMapTiles(ctx, l3bProd, allL3BProductsList, siteTiles, limitL3BPrdsPerTile);
        QList<LAIProductFormatterParams> listParams;
        NewStepList allSteps;
        //container for all global execution infos
        QList<LAIGlobalExecutionInfos> allLaiGlobalExecInfos;

        // after retrieving the L3C products is possible to have only a subset of the original L2A products
        QStringList realL2AMetaFiles;
        for(const auto &tileId : l3bMapTiles.keys())
        {
           const TileTemporalFilesInfo &listTemporalTiles = l3bMapTiles.value(tileId);
           Logger::debug(QStringLiteral("Handling tile %1 from a number of %2 tiles").arg(tileId).arg(l3bMapTiles.size()));

           allLaiGlobalExecInfos.append(LAIGlobalExecutionInfos());
           LAIGlobalExecutionInfos &infosRef = allLaiGlobalExecInfos[allLaiGlobalExecInfos.size()-1];
           infosRef.prodFormatParams.tileId = GetProductFormatterTile(tileId);
           HandleNewTilesList(ctx, event, listTemporalTiles, infosRef, bRemoveTempFiles);
           if(infosRef.allTasksList.size() > 0 && infosRef.allStepsList.size() > 0) {
               listParams.append(infosRef.prodFormatParams);
               allTasksList.append(infosRef.allTasksList);
               allSteps.append(infosRef.allStepsList);
               realL2AMetaFiles += ProcessorHandlerHelper::GetTemporalTileFiles(listTemporalTiles);
           }
        }

        // Create the product formatter tasks for the Reprocessed and/or Fitted Products (if needed)
        allTasksList.append({bNDayReproc ? "lai-reproc-product-formatter" : "lai-fitted-product-formatter", {}});
        TaskToSubmit &productFormatterTask = allTasksList[allTasksList.size()-1];
        for(LAIProductFormatterParams params: listParams) {
            productFormatterTask.parentTasks.append(params.laiReprocParams.parentsTasksRef);
        }
        SubmitTasks(ctx, event.jobId, {productFormatterTask});
        const QStringList &productFormatterArgs = GetReprocProductFormatterArgs(productFormatterTask, ctx,
                                              event, realL2AMetaFiles, listParams, !bNDayReproc);
        // add these steps to the steps list to be submitted
        allSteps.append(productFormatterTask.CreateStep("ProductFormatter", productFormatterArgs));
        ctx.SubmitSteps(allSteps);
    }

    // we add a task in order to wait for all product formatter to finish.
    // This will allow us to mark the job as finished and to remove the job folder
    SubmitEndOfLaiTask(ctx, event, allTasksList);
}

void LaiRetrievalHandlerL3C::HandleTaskFinishedImpl(EventProcessingContext &ctx,
                                             const TaskFinishedEvent &event)
{
    bool isReprocPf = false, isFittedPf = false;
    if (event.module == "lai-reproc-end-of-job") {
        ctx.MarkJobFinished(event.jobId);
        // Now remove the job folder containing temporary files
        RemoveJobFolder(ctx, event.jobId, "l3b");
    }
    if ((isReprocPf = (event.module == "lai-reproc-product-formatter")) ||
         (isFittedPf = (event.module == "lai-fitted-product-formatter"))) {
        QString prodName = GetProductFormatterProductName(ctx, event);
        QString productFolder = GetProductFormatterOutputProductPath(ctx, event);
        if((prodName != "") && ProcessorHandlerHelper::IsValidHighLevelProduct(productFolder)) {
            QString quicklook = GetProductFormatterQuicklook(ctx, event);
            QString footPrint = GetProductFormatterFootprint(ctx, event);
            ProductType prodType = ProductType::L3BProductTypeId;
            if(isReprocPf) prodType = ProductType::L3CProductTypeId;
            else if (isFittedPf) prodType = ProductType::L3DProductTypeId;

            const QStringList &prodTiles = ProcessorHandlerHelper::GetTileIdsFromHighLevelProduct(productFolder);

            // Insert the product into the database
            QDateTime minDate, maxDate;
            ProcessorHandlerHelper::GetHigLevelProductAcqDatesFromName(prodName, minDate, maxDate);
            int ret = ctx.InsertProduct({ prodType, event.processorId, event.siteId, event.jobId,
                                productFolder, maxDate, prodName,
                                quicklook, footPrint, std::experimental::nullopt, prodTiles });
            Logger::debug(QStringLiteral("InsertProduct for %1 returned %2").arg(prodName).arg(ret));

        } else {
            Logger::error(QStringLiteral("Cannot insert into database the product with name %1 and folder %2").arg(prodName).arg(productFolder));
            //ctx.MarkJobFailed(event.jobId);
        }
    }
}

QStringList LaiRetrievalHandlerL3C::GetTimeSeriesBuilderArgs(const QStringList &monoDateLaiFileNames,
                                                             const QString &allLaiTimeSeriesFileName, const QString &mainImg) {
    QStringList timeSeriesBuilderArgs = { "TimeSeriesBuilder",
      "-out", allLaiTimeSeriesFileName,
      "-main", mainImg,
      "-il"
    };
    timeSeriesBuilderArgs += monoDateLaiFileNames;

    return timeSeriesBuilderArgs;
}

QStringList LaiRetrievalHandlerL3C::GetErrTimeSeriesBuilderArgs(const QStringList &monoDateErrLaiFileNames,
                                                                const QString &allErrTimeSeriesFileName, const QString &mainImg) {
    QStringList timeSeriesBuilderArgs = { "TimeSeriesBuilder",
      "-out", allErrTimeSeriesFileName,
      "-main", mainImg,
      "-il"
    };
    timeSeriesBuilderArgs += monoDateErrLaiFileNames;

    return timeSeriesBuilderArgs;
}

QStringList LaiRetrievalHandlerL3C::GetMskFlagsTimeSeriesBuilderArgs(const QStringList &monoDateMskFlagsLaiFileNames,
                                                                     const QString &allMskFlagsTimeSeriesFileName,  const QString &mainImg) {
    QStringList timeSeriesBuilderArgs = { "TimeSeriesBuilder",
      "-out", allMskFlagsTimeSeriesFileName,
      "-main", mainImg,
      "-isflg", "1",
      "-il"
    };
    timeSeriesBuilderArgs += monoDateMskFlagsLaiFileNames;

    return timeSeriesBuilderArgs;
}

QStringList LaiRetrievalHandlerL3C::GetProfileReprocessingArgs(std::map<QString, QString> configParameters, const QString &allLaiTimeSeriesFileName,
                                       const QString &allErrTimeSeriesFileName, const QString &allMsksTimeSeriesFileName,
                                       const QString &reprocTimeSeriesFileName, const QStringList &listDates) {
    const auto &localWindowBwr = configParameters["processor.l3b.lai.localwnd.bwr"];
    const auto &localWindowFwr = configParameters["processor.l3b.lai.localwnd.fwr"];

    QStringList profileReprocessingArgs = { "ProfileReprocessing",
          "-lai", allLaiTimeSeriesFileName,
          "-err", allErrTimeSeriesFileName,
          "-msks", allMsksTimeSeriesFileName,
          "-opf", reprocTimeSeriesFileName,
          "-algo", "local",
          "-algo.local.bwr", localWindowBwr,
          "-algo.local.fwr", localWindowFwr,
          "-ildates"
    };
    profileReprocessingArgs += listDates;
    return profileReprocessingArgs;
}

QStringList LaiRetrievalHandlerL3C::GetReprocProfileSplitterArgs(const QString &reprocTimeSeriesFileName, const QString &reprocFileListFileName,
                                                              const QString &reprocFlagsFileListFileName,
                                                              const QStringList &listDates) {
    QStringList args = { "ReprocessedProfileSplitter2",
            "-in", reprocTimeSeriesFileName,
            "-outrlist", reprocFileListFileName,
            "-outflist", reprocFlagsFileListFileName,
            "-compress", "1",
            "-ildates"
    };
    args += listDates;
    return args;
}

QStringList LaiRetrievalHandlerL3C::GetFittedProfileReprocArgs(const QString &allLaiTimeSeriesFileName, const QString &allErrTimeSeriesFileName,
                                       const QString &allMsksTimeSeriesFileName, const QString &fittedTimeSeriesFileName, const QStringList &listProducts) {
    QStringList fittedProfileReprocArgs = { "ProfileReprocessing",
          "-lai", allLaiTimeSeriesFileName,
          "-err", allErrTimeSeriesFileName,
          "-msks", allMsksTimeSeriesFileName,
          "-opf", fittedTimeSeriesFileName,
          "-algo", "fit",
          "-ilxml"
    };
    fittedProfileReprocArgs += listProducts;
    return fittedProfileReprocArgs;
}

QStringList LaiRetrievalHandlerL3C::GetFittedProfileReprocSplitterArgs(const QString &fittedTimeSeriesFileName, const QString &fittedFileListFileName,
                                                                    const QString &fittedFlagsFileListFileName,
                                                                    const QStringList &allXmlsFileName) {
    QStringList args = { "ReprocessedProfileSplitter2",
                "-in", fittedTimeSeriesFileName,
                "-outrlist", fittedFileListFileName,
                "-outflist", fittedFlagsFileListFileName,
                "-compress", "1",
                "-ilxml"
    };
    args += allXmlsFileName;
    return args;
}

QStringList LaiRetrievalHandlerL3C::GetReprocProductFormatterArgs(TaskToSubmit &productFormatterTask, EventProcessingContext &ctx, const JobSubmittedEvent &event,
                                    const QStringList &listProducts, const QList<LAIProductFormatterParams> &productParams, bool isFitted) {

    std::map<QString, QString> configParameters = ctx.GetJobConfigurationParameters(event.jobId, "processor.l3b.");

    const auto &outPropsPath = productFormatterTask.GetFilePath(PRODUCT_FORMATTER_OUT_PROPS_FILE);
    const auto &executionInfosPath = productFormatterTask.GetFilePath("executionInfos.xml");

    const auto &lutFile = configParameters["processor.l3b.lai.lut_path"];

    WriteExecutionInfosFile(executionInfosPath, configParameters, listProducts, !isFitted);
    QString l3ProductType = isFitted ? "L3D" : "L3C";
    QString productShortName = isFitted ? "l3d_fitted": "l3c_reproc";
    const auto &targetFolder = GetFinalProductFolder(ctx, event.jobId, event.siteId, productShortName);

    QStringList productFormatterArgs = { "ProductFormatter",
                            "-destroot", targetFolder,
                            "-fileclass", "OPER",
                            "-level", l3ProductType,
                            "-baseline", "01.00",
                            "-siteid", QString::number(event.siteId),
                            "-processor", "vegetation",
                            "-gipp", executionInfosPath,
                            "-outprops", outPropsPath};
    productFormatterArgs += "-il";
    productFormatterArgs += listProducts;

    if(lutFile.size() > 0) {
        productFormatterArgs += "-lut";
        productFormatterArgs += lutFile;
    }

    productFormatterArgs += (isFitted ? "-processor.vegetation.filelaifit" : "-processor.vegetation.filelaireproc");
    for(const LAIProductFormatterParams &params: productParams) {
        productFormatterArgs += params.tileId;
        productFormatterArgs += params.laiReprocParams.fileLaiReproc;
    }
    productFormatterArgs += (isFitted ? "-processor.vegetation.filelaifitflgs" : "-processor.vegetation.filelaireprocflgs");
    for(const LAIProductFormatterParams &params: productParams) {
        productFormatterArgs += params.tileId;
        productFormatterArgs += params.laiReprocParams.fileLaiReprocFlgs;
    }

    return productFormatterArgs;
}

int LaiRetrievalHandlerL3C::GetIntParameterValue(const QJsonObject &parameters, const QString &key, int defVal)
{
    int retVal = defVal;
    if(parameters.contains(key)) {
        const auto &value = parameters[key];
        if(value.isDouble())
            retVal = value.toInt();
        else if(value.isString()) {
            retVal = value.toString().toInt();
        }
    }
    return retVal;
}

bool LaiRetrievalHandlerL3C::IsNDayReproc(const QJsonObject &parameters, std::map<QString, QString> &configParameters) {
    bool bNDayReproc = false;
    if(parameters.contains("reproc")) {
        const auto &value = parameters["reproc"];
        if(value.isDouble())
            bNDayReproc = (value.toInt() != 0);
        else if(value.isString()) {
            bNDayReproc = (value.toString() == "1");
        }
    } else {
        bNDayReproc = ((configParameters["processor.l3b.reprocess"]).toInt() != 0);
    }
    return bNDayReproc;
}

bool LaiRetrievalHandlerL3C::IsFittedReproc(const QJsonObject &parameters, std::map<QString, QString> &configParameters) {
    bool bFittedReproc = false;
    if(parameters.contains("fitted")) {
        const auto &value = parameters["fitted"];
        if(value.isDouble())
            bFittedReproc = (value.toInt() != 0);
        else if(value.isString()) {
            bFittedReproc = (value.toString() == "1");
        }
    } else {
        bFittedReproc = ((configParameters["processor.l3b.fitted"]).toInt() != 0);
    }
    return bFittedReproc;
}

ProcessorJobDefinitionParams LaiRetrievalHandlerL3C::GetProcessingDefinitionImpl(SchedulingContext &ctx, int siteId, int scheduledDate,
                                                          const ConfigurationParameterValueMap &requestOverrideCfgValues)
{
    ProcessorJobDefinitionParams params;
    params.isValid = false;

    QDateTime seasonStartDate;
    QDateTime seasonEndDate;
    // extract the scheduled date
    QDateTime qScheduledDate = QDateTime::fromTime_t(scheduledDate);
    GetSeasonStartEndDates(ctx, siteId, seasonStartDate, seasonEndDate, qScheduledDate, requestOverrideCfgValues);
    QDateTime limitDate = seasonEndDate.addMonths(2);
    if(qScheduledDate > limitDate) {
        return params;
    }
    if(!seasonStartDate.isValid()) {
        Logger::error(QStringLiteral("Season start date for site ID %1 is invalid in the database!")
                      .arg(siteId));
        return params;
    }

    ConfigurationParameterValueMap mapCfg = ctx.GetConfigurationParameters(QString("processor.l3b."), siteId, requestOverrideCfgValues);

    // we might have an offset in days from starting the downloading products to start the L3C/L3D production
    int startSeasonOffset = mapCfg["processor.l3b.start_season_offset"].value.toInt();
    seasonStartDate = seasonStartDate.addDays(startSeasonOffset);

    int generateReprocess = false;
    int generateFitted = false;

    if(requestOverrideCfgValues.contains("product_type")) {
        const ConfigurationParameterValue &productType = requestOverrideCfgValues["product_type"];
        if(productType.value == "L3C") {
            generateReprocess = true;
            params.jsonParameters = "{ \"reproc\": \"1\", \"inputs_are_l3b\" : \"1\", \"max_l3b_per_tile\" : \"3\"}";
        } else if(productType.value == "L3D") {
            generateFitted = true;
            params.jsonParameters = "{ \"fitted\": \"1\", \"inputs_are_l3b\" : \"1\"}";
        }
    }
    // we need to have at least one flag set
    if(!generateReprocess && !generateFitted) {
        return params;
    }

    // by default the start date is the season start date
    QDateTime startDate = seasonStartDate;
    QDateTime endDate = qScheduledDate;

    if(generateReprocess) {
        int productionInterval = mapCfg["processor.l3b.reproc_production_interval"].value.toInt();
        startDate = endDate.addDays(-productionInterval);
        // Use only the products after the configured start season date
        if(startDate < seasonStartDate) {
            startDate = seasonStartDate;
        }
    }

    params.productList = ctx.GetProducts(siteId, (int)ProductType::L3BProductTypeId, startDate, endDate);
    // Normally, we need at least 3 product available in order to be able to create a L3C/L3D product
    // but if we do not return here, the schedule block waiting for products (that might never happen)
    bool waitForAvailProcInputs = (mapCfg["processor.l3b.sched_wait_proc_inputs"].value.toInt() != 0);
    if((waitForAvailProcInputs == false) || (params.productList.size() > 3)) {
        params.isValid = true;
        Logger::debug(QStringLiteral("Executing scheduled job. Scheduler extracted for L3C/L3D a number "
                                     "of %1 products for site ID %2 with start date %3 and end date %4!")
                      .arg(params.productList.size())
                      .arg(siteId)
                      .arg(startDate.toString())
                      .arg(endDate.toString()));
    } else {
        Logger::debug(QStringLiteral("Scheduled job for L3C/L3D and site ID %1 with start date %2 and end date %3 "
                                     "will not be executed (no products)!")
                      .arg(siteId)
                      .arg(startDate.toString())
                      .arg(endDate.toString()));
    }

    return params;
}

