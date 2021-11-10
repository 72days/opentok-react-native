package com.opentokreactnative.utils;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableArray;
import com.opentok.android.Connection;
import com.opentok.android.OpentokError;
import com.opentok.android.Session;
import com.opentok.android.Stream;
import com.opentok.android.SubscriberKit;
import com.opentok.android.PublisherKit;

public final class EventUtils {

    public static WritableMap prepareJSConnectionMap(Connection connection) {

        WritableMap connectionInfo = Arguments.createMap();
        if (connection != null) {
            connectionInfo.putString("connectionId", connection.getConnectionId());
            connectionInfo.putString("creationTime", connection.getCreationTime().toString());
            connectionInfo.putString("data", connection.getData());
        }
        return connectionInfo;
    }

    public static WritableMap prepareJSStreamMap(Stream stream, Session session) {

        WritableMap streamInfo = Arguments.createMap();
        if (stream != null) {
            streamInfo.putString("streamId", stream.getStreamId());
            streamInfo.putInt("height", stream.getVideoHeight());
            streamInfo.putInt("width", stream.getVideoWidth());
            streamInfo.putString("creationTime", stream.getCreationTime().toString());
            streamInfo.putString("connectionId", stream.getConnection().getConnectionId());
            streamInfo.putString("sessionId", session.getSessionId());
            streamInfo.putMap("connection", prepareJSConnectionMap(stream.getConnection()));
            streamInfo.putString("name", stream.getName());
            streamInfo.putBoolean("hasAudio", stream.hasAudio());
            streamInfo.putBoolean("hasVideo", stream.hasVideo());
            if (stream.getStreamVideoType().equals(Stream.StreamVideoType.StreamVideoTypeScreen)) {
                streamInfo.putString("videoType", "screen");
            } else {
                streamInfo.putString("videoType", "camera");
            }
        }
        return streamInfo;
    }

    public static WritableMap prepareJSErrorMap(OpentokError error) {

        WritableMap errorInfo = Arguments.createMap();
        errorInfo.putString("message", error.getMessage());
        errorInfo.putString("code", error.getErrorCode().toString());
        return errorInfo;
    }

    public static WritableMap prepareJSSessionMap(Session session) {

        WritableMap sessionInfo = Arguments.createMap();
        sessionInfo.putString("sessionId", session.getSessionId());
        if (session.getConnection() != null) {
            WritableMap connectionInfo = prepareJSConnectionMap(session.getConnection());
            sessionInfo.putMap("connection", connectionInfo);
        }
        return sessionInfo;
    }

    public static WritableMap prepareStreamPropertyChangedEventData(String changedProperty, String oldValue, String newValue, Stream stream, Session session) {

        WritableMap streamPropertyEventData = Arguments.createMap();
        streamPropertyEventData.putString("changedProperty", changedProperty);
        streamPropertyEventData.putString("oldValue", oldValue);
        streamPropertyEventData.putString("newValue", newValue);
        streamPropertyEventData.putMap("stream", prepareJSStreamMap(stream, session));
        return streamPropertyEventData;
    }

    public static WritableMap prepareStreamPropertyChangedEventData(String changedProperty, WritableMap oldValue, WritableMap newValue, Stream stream, Session session) {

        WritableMap streamPropertyEventData = Arguments.createMap();
        streamPropertyEventData.putString("changedProperty", changedProperty);
        streamPropertyEventData.putMap("oldValue", oldValue);
        streamPropertyEventData.putMap("newValue", newValue);
        streamPropertyEventData.putMap("stream", prepareJSStreamMap(stream, session));
        return streamPropertyEventData;
    }

    public static WritableMap prepareStreamPropertyChangedEventData(String changedProperty, Boolean oldValue, Boolean newValue, Stream stream, Session session) {

        WritableMap streamPropertyEventData = Arguments.createMap();
        streamPropertyEventData.putString("changedProperty", changedProperty);
        streamPropertyEventData.putBoolean("oldValue", oldValue);
        streamPropertyEventData.putBoolean("newValue", newValue);
        streamPropertyEventData.putMap("stream", prepareJSStreamMap(stream, session));
        return streamPropertyEventData;
    }

    public static WritableMap prepareSubscriberAudioNetworkStats(SubscriberKit.SubscriberAudioStats stats) {

        WritableMap audioStats = Arguments.createMap();
        audioStats.putInt("audioPacketsLost", stats.audioPacketsLost);
        audioStats.putInt("audioBytesReceived", stats.audioBytesReceived);
        audioStats.putInt("audioPacketsReceived", stats.audioPacketsReceived);
        return audioStats;
    }

    public static WritableMap preparePublisherAudioNetworkStats(PublisherKit.PublisherAudioStats[] stats) {

        WritableMap eventData = Arguments.createMap();
        WritableArray jsStatsList = Arguments.createArray();

        for (PublisherKit.PublisherAudioStats statsItem : stats) {
            WritableMap jsDataItem = Arguments.createMap();
            jsDataItem.putString("connectionId", statsItem.connectionId);
            jsDataItem.putString("subscriberId", statsItem.subscriberId);
            jsDataItem.putDouble("timestamp", statsItem.timeStamp);
            jsDataItem.putDouble("audioPacketsLost", statsItem.audioPacketsLost);
            jsDataItem.putDouble("audioBytesSent", statsItem.audioBytesSent);
            jsDataItem.putDouble("audioPacketsSent", statsItem.audioPacketsSent);
            jsStatsList.pushMap(jsDataItem);
        }
        
        eventData.putArray("data", jsStatsList);
        return eventData;
    }

    public static WritableMap prepareSubscriberVideoNetworkStats(SubscriberKit.SubscriberVideoStats stats) {

        WritableMap videoStats = Arguments.createMap();
        videoStats.putInt("videoPacketsLost", stats.videoPacketsLost);
        videoStats.putInt("videoBytesReceived", stats.videoBytesReceived);
        videoStats.putInt("videoPacketsReceived", stats.videoPacketsReceived);
        return videoStats;
    }

    public static WritableMap preparePublisherVideoNetworkStats(PublisherKit.PublisherVideoStats[] stats) {

        WritableMap eventData = Arguments.createMap();
        WritableArray jsStatsList = Arguments.createArray();

        for (PublisherKit.PublisherVideoStats statsItem : stats) {
            WritableMap jsDataItem = Arguments.createMap();
            jsDataItem.putString("connectionId", statsItem.connectionId);
            jsDataItem.putString("subscriberId", statsItem.subscriberId);
            jsDataItem.putDouble("timestamp", statsItem.timeStamp);
            jsDataItem.putDouble("videoPacketsLost", statsItem.videoPacketsLost);
            jsDataItem.putDouble("videoPacketsSent", statsItem.videoPacketsSent);
            jsDataItem.putDouble("videoBytesSent", statsItem.videoBytesSent);
            jsStatsList.pushMap(jsDataItem);
        }
        
        eventData.putArray("data", jsStatsList);
        return eventData;
    }

    public static WritableMap preparePublisherRTCStatsReport(PublisherKit.PublisherRtcStats[] rtcStatsReport) {

        WritableMap rtcStatsReportData = Arguments.createMap();
        WritableArray reports = Arguments.createArray();

        for (PublisherKit.PublisherRtcStats rtcStatsReportItem : rtcStatsReport) {
            WritableMap jsDataItem = Arguments.createMap();
            jsDataItem.putString("connectionId", rtcStatsReportItem.connectionId);
            jsDataItem.putString("jsonArrayOfReports", rtcStatsReportItem.jsonArrayOfReports);
            reports.pushMap(jsDataItem);
        }
        
        rtcStatsReportData.putArray("data", reports);
        return rtcStatsReportData;
    }

    public static WritableMap prepareSubscriberRTCStatsReport(String jsonArrayOfReports) {
        WritableMap rtcStatsReportData = Arguments.createMap();
        rtcStatsReportData.putString("data", jsonArrayOfReports);
        return rtcStatsReportData;
    }

    public static WritableMap createError(String message) {

        WritableMap errorInfo = Arguments.createMap();
        errorInfo.putString("message", message);
        return errorInfo;
    }
}
