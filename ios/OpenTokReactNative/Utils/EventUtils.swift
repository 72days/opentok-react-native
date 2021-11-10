//
//  EventUtils.swift
//  OpenTokReactNative
//
//  Created by Manik Sachdeva on 11/3/18.
//  Copyright © 2018 TokBox Inc. All rights reserved.
//

import Foundation

class EventUtils {
    
    static var sessionPreface: String = "session:";
    static var publisherPreface: String = "publisher:";
    static var subscriberPreface: String = "subscriber:";
    
    static func prepareJSConnectionEventData(_ connection: OTConnection) -> Dictionary<String, Any> {
        var connectionInfo: Dictionary<String, Any> = [:];
        guard connection != nil else { return connectionInfo }
        connectionInfo["connectionId"] = connection.connectionId;
        connectionInfo["creationTime"] = convertDateToString(connection.creationTime);
        connectionInfo["data"] = connection.data;
        return connectionInfo;
    }
    
    static func prepareJSStreamEventData(_ stream: OTStream) -> Dictionary<String, Any> {
        var streamInfo: Dictionary<String, Any> = [:];
        guard OTRN.sharedState.sessions[stream.session.sessionId] != nil else { return streamInfo }
        streamInfo["streamId"] = stream.streamId;
        streamInfo["name"] = stream.name;
        streamInfo["connectionId"] = stream.connection.connectionId;
        streamInfo["connection"] = prepareJSConnectionEventData(stream.connection);
        streamInfo["hasAudio"] = stream.hasAudio;
        streamInfo["sessionId"] = stream.session.sessionId;
        streamInfo["hasVideo"] = stream.hasVideo;
        streamInfo["creationTime"] = convertDateToString(stream.creationTime);
        streamInfo["height"] = stream.videoDimensions.height;
        streamInfo["width"] = stream.videoDimensions.width;
        streamInfo["videoType"] = stream.videoType == OTStreamVideoType.screen ? "screen" : "camera"
        return streamInfo;
    }
    
    static func prepareJSErrorEventData(_ error: OTError) -> Dictionary<String, Any> {
        var errorInfo: Dictionary<String, Any> = [:];
        errorInfo["code"] = error.code;
        errorInfo["message"] = error.localizedDescription;
        return errorInfo;
    }
    
    static func prepareStreamPropertyChangedEventData(_ changedProperty: String, oldValue: Any, newValue: Any, stream: Dictionary<String, Any>) -> Dictionary<String, Any> {
        var streamPropertyEventData: Dictionary<String, Any> = [:];
        streamPropertyEventData["oldValue"] = oldValue;
        streamPropertyEventData["newValue"] = newValue;
        streamPropertyEventData["stream"] = stream;
        streamPropertyEventData["changedProperty"] = changedProperty;
        return streamPropertyEventData
    }
    
    static func prepareSubscriberVideoNetworkStatsEventData(_ videoStats: OTSubscriberKitVideoNetworkStats) -> Dictionary<String, Any> {
        var videoStatsEventData: Dictionary<String, Any> = [:];
        videoStatsEventData["videoPacketsLost"] = videoStats.videoPacketsLost;
        videoStatsEventData["videoBytesReceived"] = videoStats.videoBytesReceived;
        videoStatsEventData["videoPacketsReceived"] = videoStats.videoPacketsReceived;
        return videoStatsEventData;
    }
    
    static func preparePublisherVideoNetworkStatsEventData(_ videoStats: Array<OTPublisherKitVideoNetworkStats>) -> Dictionary<String, Any> {
        var eventData: Dictionary<String, Any> = [:];
        var stats = [Dictionary<String, Any>]()
        for statsItem in videoStats {
            var jsStatsItem: Dictionary<String, Any> = [:];
            jsStatsItem["connectionId"] = statsItem.connectionId;
            jsStatsItem["subscriberId"] = statsItem.subscriberId;
            jsStatsItem["timestamp"] = statsItem.timestamp;
            jsStatsItem["videoPacketsLost"] = statsItem.videoPacketsLost;
            jsStatsItem["videoPacketsSent"] = statsItem.videoPacketsSent;
            jsStatsItem["videoBytesSent"] = statsItem.videoBytesSent;
            stats.append(jsStatsItem)
        }
        eventData["data"] = stats
        return eventData;
    }
    
    static func prepareSubscriberAudioNetworkStatsEventData(_ audioStats: OTSubscriberKitAudioNetworkStats) -> Dictionary<String, Any> {
        var audioStatsEventData: Dictionary<String, Any> = [:];
        audioStatsEventData["audioPacketsLost"] = audioStats.audioPacketsLost;
        audioStatsEventData["audioBytesReceived"] = audioStats.audioBytesReceived;
        audioStatsEventData["audioPacketsReceived"] = audioStats.audioPacketsReceived;
        return audioStatsEventData;
    }
    
    static func prepareJSSessionEventData(_ session: OTSession) -> Dictionary<String, Any> {
        var sessionInfo: Dictionary<String, Any> = [:];
        sessionInfo["sessionId"] = session.sessionId;
        guard let connection = session.connection else { return sessionInfo };
        sessionInfo["connection"] = prepareJSConnectionEventData(connection);
        return sessionInfo;
    }
    
    static func prepareJSPublisherRTCStatsReport(_ rtcStatsReport: Array<OTPublisherRtcStats>) -> Dictionary<String, Any> {
        var rtcStatsReportData: Dictionary<String, Any> = [:];
        var reports = [Dictionary<String, Any>]()
        for rtcStatsReportItem in rtcStatsReport {
            var jsDataItem: Dictionary<String, Any> = [:];
            jsDataItem["connectionId"] = rtcStatsReportItem.connectionId
            jsDataItem["jsonArrayOfReports"] = rtcStatsReportItem.jsonArrayOfReports
            reports.append(jsDataItem)
        }
        rtcStatsReportData["data"] = reports
        return rtcStatsReportData;
    }
    
    static func prepareJSSubscriberRTCStatsReport(_ jsonArrayOfReports: String) -> Dictionary<String, Any> {
        var rtcStatsReportData: Dictionary<String, Any> = [:];
        rtcStatsReportData["data"] = jsonArrayOfReports
        return rtcStatsReportData;
    }
    
    static func getSupportedEvents() -> [String] {
        return [
            "\(sessionPreface)streamCreated",
            "\(sessionPreface)streamDestroyed",
            "\(sessionPreface)sessionDidConnect",
            "\(sessionPreface)sessionDidDisconnect",
            "\(sessionPreface)connectionCreated",
            "\(sessionPreface)connectionDestroyed",
            "\(sessionPreface)didFailWithError", 
            "\(sessionPreface)signal",
            "\(sessionPreface)archiveStartedWithId",
            "\(sessionPreface)archiveStoppedWithId",
            "\(sessionPreface)sessionDidBeginReconnecting",
            "\(sessionPreface)sessionDidReconnect",
            "\(sessionPreface)streamPropertyChanged",

            "\(publisherPreface)streamCreated",
            "\(publisherPreface)streamDestroyed",
            "\(publisherPreface)didFailWithError",
            "\(publisherPreface)audioLevelUpdated",
            "\(publisherPreface)videoNetworkStatsUpdated",
            "\(publisherPreface)rtcStatsReportUpdated",

            "\(subscriberPreface)subscriberDidConnect",
            "\(subscriberPreface)subscriberDidDisconnect",
            "\(subscriberPreface)didFailWithError",
            "\(subscriberPreface)videoNetworkStatsUpdated",
            "\(subscriberPreface)audioNetworkStatsUpdated",
            "\(subscriberPreface)audioLevelUpdated",
            "\(subscriberPreface)rtcStatsReportUpdated",
            "\(subscriberPreface)subscriberVideoEnabled",
            "\(subscriberPreface)subscriberVideoDisabled",
            "\(subscriberPreface)subscriberVideoDisableWarning",
            "\(subscriberPreface)subscriberVideoDisableWarningLifted",
            "\(subscriberPreface)subscriberVideoDataReceived",
            "\(subscriberPreface)subscriberDidReconnect"
        ];
    }
    
    static func convertDateToString(_ creationTime: Date) -> String {
        let dateFormatter: DateFormatter = DateFormatter();
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss";
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC");
        return dateFormatter.string(from:creationTime);
    }

    static func createErrorMessage(_ message: String) -> Dictionary<String, String> {
        var errorInfo: Dictionary<String, String> = [:]
        errorInfo["message"] = message
        return errorInfo
    }
    
}
