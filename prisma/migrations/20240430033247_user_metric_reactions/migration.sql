-- AlterTable
ALTER TABLE "UserMetric" ADD COLUMN     "reactionCount" INTEGER NOT NULL DEFAULT 0;

CREATE OR REPLACE VIEW "UserStat" AS
WITH user_model_metrics_timeframe AS (
         SELECT m."userId",
            mm.timeframe,
            sum(mm."downloadCount") AS "downloadCount",
            sum(mm."favoriteCount") AS "favoriteCount",
            sum(mm."ratingCount") AS "ratingCount",
            iif(sum(mm."ratingCount") IS NULL OR sum(mm."ratingCount") <= 0, 0::double precision, sum(mm.rating * mm."ratingCount"::double precision) / sum(mm."ratingCount")::double precision) AS rating,
            sum(mm."thumbsUpCount") AS "thumbsUpCount"
           FROM "ModelMetric" mm
             JOIN "Model" m ON m.id = mm."modelId"
          GROUP BY m."userId", mm.timeframe
        ), user_model_metrics AS (
         SELECT user_model_metrics_timeframe."userId",
            max(iif(user_model_metrics_timeframe.timeframe = 'Day'::"MetricTimeframe", user_model_metrics_timeframe."downloadCount", NULL::bigint)) AS "downloadCountDay",
            max(iif(user_model_metrics_timeframe.timeframe = 'Week'::"MetricTimeframe", user_model_metrics_timeframe."downloadCount", NULL::bigint)) AS "downloadCountWeek",
            max(iif(user_model_metrics_timeframe.timeframe = 'Month'::"MetricTimeframe", user_model_metrics_timeframe."downloadCount", NULL::bigint)) AS "downloadCountMonth",
            max(iif(user_model_metrics_timeframe.timeframe = 'Year'::"MetricTimeframe", user_model_metrics_timeframe."downloadCount", NULL::bigint)) AS "downloadCountYear",
            max(iif(user_model_metrics_timeframe.timeframe = 'AllTime'::"MetricTimeframe", user_model_metrics_timeframe."downloadCount", NULL::bigint)) AS "downloadCountAllTime",
            max(iif(user_model_metrics_timeframe.timeframe = 'Day'::"MetricTimeframe", user_model_metrics_timeframe."favoriteCount", NULL::bigint)) AS "favoriteCountDay",
            max(iif(user_model_metrics_timeframe.timeframe = 'Week'::"MetricTimeframe", user_model_metrics_timeframe."favoriteCount", NULL::bigint)) AS "favoriteCountWeek",
            max(iif(user_model_metrics_timeframe.timeframe = 'Month'::"MetricTimeframe", user_model_metrics_timeframe."favoriteCount", NULL::bigint)) AS "favoriteCountMonth",
            max(iif(user_model_metrics_timeframe.timeframe = 'Year'::"MetricTimeframe", user_model_metrics_timeframe."favoriteCount", NULL::bigint)) AS "favoriteCountYear",
            max(iif(user_model_metrics_timeframe.timeframe = 'AllTime'::"MetricTimeframe", user_model_metrics_timeframe."favoriteCount", NULL::bigint)) AS "favoriteCountAllTime",
            max(iif(user_model_metrics_timeframe.timeframe = 'Day'::"MetricTimeframe", user_model_metrics_timeframe."ratingCount", NULL::bigint)) AS "ratingCountDay",
            max(iif(user_model_metrics_timeframe.timeframe = 'Week'::"MetricTimeframe", user_model_metrics_timeframe."ratingCount", NULL::bigint)) AS "ratingCountWeek",
            max(iif(user_model_metrics_timeframe.timeframe = 'Month'::"MetricTimeframe", user_model_metrics_timeframe."ratingCount", NULL::bigint)) AS "ratingCountMonth",
            max(iif(user_model_metrics_timeframe.timeframe = 'Year'::"MetricTimeframe", user_model_metrics_timeframe."ratingCount", NULL::bigint)) AS "ratingCountYear",
            max(iif(user_model_metrics_timeframe.timeframe = 'AllTime'::"MetricTimeframe", user_model_metrics_timeframe."ratingCount", NULL::bigint)) AS "ratingCountAllTime",
            max(iif(user_model_metrics_timeframe.timeframe = 'Day'::"MetricTimeframe", user_model_metrics_timeframe.rating, NULL::double precision)) AS "ratingDay",
            max(iif(user_model_metrics_timeframe.timeframe = 'Week'::"MetricTimeframe", user_model_metrics_timeframe.rating, NULL::double precision)) AS "ratingWeek",
            max(iif(user_model_metrics_timeframe.timeframe = 'Month'::"MetricTimeframe", user_model_metrics_timeframe.rating, NULL::double precision)) AS "ratingMonth",
            max(iif(user_model_metrics_timeframe.timeframe = 'Year'::"MetricTimeframe", user_model_metrics_timeframe.rating, NULL::double precision)) AS "ratingYear",
            max(iif(user_model_metrics_timeframe.timeframe = 'AllTime'::"MetricTimeframe", user_model_metrics_timeframe.rating, NULL::double precision)) AS "ratingAllTime",
            max(iif(user_model_metrics_timeframe.timeframe = 'Day'::"MetricTimeframe", user_model_metrics_timeframe."thumbsUpCount", NULL::bigint)) AS "thumbsUpCountDay",
            max(iif(user_model_metrics_timeframe.timeframe = 'Week'::"MetricTimeframe", user_model_metrics_timeframe."thumbsUpCount", NULL::bigint)) AS "thumbsUpCountWeek",
            max(iif(user_model_metrics_timeframe.timeframe = 'Month'::"MetricTimeframe", user_model_metrics_timeframe."thumbsUpCount", NULL::bigint)) AS "thumbsUpCountMonth",
            max(iif(user_model_metrics_timeframe.timeframe = 'Year'::"MetricTimeframe", user_model_metrics_timeframe."thumbsUpCount", NULL::bigint)) AS "thumbsUpCountYear",
            max(iif(user_model_metrics_timeframe.timeframe = 'AllTime'::"MetricTimeframe", user_model_metrics_timeframe."thumbsUpCount", NULL::bigint)) AS "thumbsUpCountAllTime"
           FROM user_model_metrics_timeframe
          GROUP BY user_model_metrics_timeframe."userId"
        ), user_counts_timeframe AS (
         SELECT um."userId",
            um.timeframe,
            COALESCE(sum(um."followingCount"), 0::bigint) AS "followingCount",
            COALESCE(sum(um."followerCount"), 0::bigint) AS "followerCount",
            COALESCE(sum(um."hiddenCount"), 0::bigint) AS "hiddenCount",
            COALESCE(sum(um."uploadCount"), 0::bigint) AS "uploadCount",
            COALESCE(sum(um."reviewCount"), 0::bigint) AS "reviewCount",
            COALESCE(sum(um."answerCount"), 0::bigint) AS "answerCount",
            COALESCE(sum(um."answerAcceptCount"), 0::bigint) AS "answerAcceptCount",
            COALESCE(sum(um."reactionCount"), 0::bigint) AS "reactionCount"
           FROM "UserMetric" um
          GROUP BY um."userId", um.timeframe
        ), user_counts AS (
         SELECT user_counts_timeframe."userId",
            max(iif(user_counts_timeframe.timeframe = 'Day'::"MetricTimeframe", user_counts_timeframe."followerCount", NULL::bigint)) AS "followerCountDay",
            max(iif(user_counts_timeframe.timeframe = 'Day'::"MetricTimeframe", user_counts_timeframe."followingCount", NULL::bigint)) AS "followingCountDay",
            max(iif(user_counts_timeframe.timeframe = 'Day'::"MetricTimeframe", user_counts_timeframe."hiddenCount", NULL::bigint)) AS "hiddenCountDay",
            max(iif(user_counts_timeframe.timeframe = 'Week'::"MetricTimeframe", user_counts_timeframe."followerCount", NULL::bigint)) AS "followerCountWeek",
            max(iif(user_counts_timeframe.timeframe = 'Week'::"MetricTimeframe", user_counts_timeframe."followingCount",NULL::bigint)) AS "followingCountWeek",
            max(iif(user_counts_timeframe.timeframe = 'Week'::"MetricTimeframe", user_counts_timeframe."hiddenCount", NULL::bigint)) AS "hiddenCountWeek",
            max(iif(user_counts_timeframe.timeframe = 'Month'::"MetricTimeframe", user_counts_timeframe."followerCount",NULL::bigint)) AS "followerCountMonth",
            max(iif(user_counts_timeframe.timeframe = 'Month'::"MetricTimeframe", user_counts_timeframe."followingCount", NULL::bigint)) AS "followingCountMonth",
            max(iif(user_counts_timeframe.timeframe = 'Month'::"MetricTimeframe", user_counts_timeframe."hiddenCount", NULL::bigint)) AS "hiddenCountMonth",
            max(iif(user_counts_timeframe.timeframe = 'Year'::"MetricTimeframe", user_counts_timeframe."followerCount", NULL::bigint)) AS "followerCountYear",
            max(iif(user_counts_timeframe.timeframe = 'Year'::"MetricTimeframe", user_counts_timeframe."followingCount",NULL::bigint)) AS "followingCountYear",
            max(iif(user_counts_timeframe.timeframe = 'Year'::"MetricTimeframe", user_counts_timeframe."hiddenCount", NULL::bigint)) AS "hiddenCountYear",
            max(iif(user_counts_timeframe.timeframe = 'AllTime'::"MetricTimeframe", user_counts_timeframe."followerCount", NULL::bigint)) AS "followerCountAllTime",
            max(iif(user_counts_timeframe.timeframe = 'AllTime'::"MetricTimeframe", user_counts_timeframe."followingCount", NULL::bigint)) AS "followingCountAllTime",
            max(iif(user_counts_timeframe.timeframe = 'AllTime'::"MetricTimeframe", user_counts_timeframe."hiddenCount",NULL::bigint)) AS "hiddenCountAllTime",
            max(iif(user_counts_timeframe.timeframe = 'Day'::"MetricTimeframe", user_counts_timeframe."uploadCount", NULL::bigint)) AS "uploadCountDay",
            max(iif(user_counts_timeframe.timeframe = 'Week'::"MetricTimeframe", user_counts_timeframe."uploadCount", NULL::bigint)) AS "uploadCountWeek",
            max(iif(user_counts_timeframe.timeframe = 'Month'::"MetricTimeframe", user_counts_timeframe."uploadCount", NULL::bigint)) AS "uploadCountMonth",
            max(iif(user_counts_timeframe.timeframe = 'Year'::"MetricTimeframe", user_counts_timeframe."uploadCount", NULL::bigint)) AS "uploadCountYear",
            max(iif(user_counts_timeframe.timeframe = 'AllTime'::"MetricTimeframe", user_counts_timeframe."uploadCount",NULL::bigint)) AS "uploadCountAllTime",
            max(iif(user_counts_timeframe.timeframe = 'Day'::"MetricTimeframe", user_counts_timeframe."reviewCount", NULL::bigint)) AS "reviewCountDay",
            max(iif(user_counts_timeframe.timeframe = 'Week'::"MetricTimeframe", user_counts_timeframe."reviewCount", NULL::bigint)) AS "reviewCountWeek",
            max(iif(user_counts_timeframe.timeframe = 'Month'::"MetricTimeframe", user_counts_timeframe."reviewCount", NULL::bigint)) AS "reviewCountMonth",
            max(iif(user_counts_timeframe.timeframe = 'Year'::"MetricTimeframe", user_counts_timeframe."reviewCount", NULL::bigint)) AS "reviewCountYear",
            max(iif(user_counts_timeframe.timeframe = 'AllTime'::"MetricTimeframe", user_counts_timeframe."reviewCount",NULL::bigint)) AS "reviewCountAllTime",
            max(iif(user_counts_timeframe.timeframe = 'Day'::"MetricTimeframe", user_counts_timeframe."answerCount", NULL::bigint)) AS "answerCountDay",
            max(iif(user_counts_timeframe.timeframe = 'Week'::"MetricTimeframe", user_counts_timeframe."answerCount", NULL::bigint)) AS "answerCountWeek",
            max(iif(user_counts_timeframe.timeframe = 'Month'::"MetricTimeframe", user_counts_timeframe."answerCount", NULL::bigint)) AS "answerCountMonth",
            max(iif(user_counts_timeframe.timeframe = 'Year'::"MetricTimeframe", user_counts_timeframe."answerCount", NULL::bigint)) AS "answerCountYear",
            max(iif(user_counts_timeframe.timeframe = 'AllTime'::"MetricTimeframe", user_counts_timeframe."answerCount",NULL::bigint)) AS "answerCountAllTime",
            max(iif(user_counts_timeframe.timeframe = 'Day'::"MetricTimeframe", user_counts_timeframe."answerAcceptCount", NULL::bigint)) AS "answerAcceptCountDay",
            max(iif(user_counts_timeframe.timeframe = 'Week'::"MetricTimeframe", user_counts_timeframe."answerAcceptCount", NULL::bigint)) AS "answerAcceptCountWeek",
            max(iif(user_counts_timeframe.timeframe = 'Month'::"MetricTimeframe", user_counts_timeframe."answerAcceptCount", NULL::bigint)) AS "answerAcceptCountMonth",
            max(iif(user_counts_timeframe.timeframe = 'Year'::"MetricTimeframe", user_counts_timeframe."answerAcceptCount", NULL::bigint)) AS "answerAcceptCountYear",
            max(iif(user_counts_timeframe.timeframe = 'AllTime'::"MetricTimeframe", user_counts_timeframe."answerAcceptCount", NULL::bigint)) AS "answerAcceptCountAllTime", 
            max(iif(user_counts_timeframe.timeframe = 'Day'::"MetricTimeframe", user_counts_timeframe."reactionCount", NULL::bigint)) AS "reactionCountDay",
            max(iif(user_counts_timeframe.timeframe = 'Week'::"MetricTimeframe", user_counts_timeframe."reactionCount", NULL::bigint)) AS "reactionCountWeek",
            max(iif(user_counts_timeframe.timeframe = 'Month'::"MetricTimeframe", user_counts_timeframe."reactionCount", NULL::bigint)) AS "reactionCountMonth",
            max(iif(user_counts_timeframe.timeframe = 'Year'::"MetricTimeframe", user_counts_timeframe."reactionCount", NULL::bigint)) AS "reactionCountYear",
            max(iif(user_counts_timeframe.timeframe = 'AllTime'::"MetricTimeframe", user_counts_timeframe."reactionCount",NULL::bigint)) AS "reactionCountAllTime"
           FROM user_counts_timeframe
          GROUP BY user_counts_timeframe."userId"
        ), full_user_stats AS (
         SELECT u."userId",
            u."followerCountDay",
            u."followingCountDay",
            u."hiddenCountDay",
            u."followerCountWeek",
            u."followingCountWeek",
            u."hiddenCountWeek",
            u."followerCountMonth",
            u."followingCountMonth",
            u."hiddenCountMonth",
            u."followerCountYear",
            u."followingCountYear",
            u."hiddenCountYear",
            u."followerCountAllTime",
            u."followingCountAllTime",
            u."hiddenCountAllTime",
            u."uploadCountDay",
            u."uploadCountWeek",
            u."uploadCountMonth",
            u."uploadCountYear",
            u."uploadCountAllTime",
            u."reviewCountDay",
            u."reviewCountWeek",
            u."reviewCountMonth",
            u."reviewCountYear",
            u."reviewCountAllTime",
            u."answerCountDay",
            u."answerCountWeek",
            u."answerCountMonth",
            u."answerCountYear",
            u."answerCountAllTime",
            u."answerAcceptCountDay",
            u."answerAcceptCountWeek",
            u."answerAcceptCountMonth",
            u."answerAcceptCountYear",
            u."answerAcceptCountAllTime",
            COALESCE(m."downloadCountDay", 0::bigint) AS "downloadCountDay",
            COALESCE(m."downloadCountWeek", 0::bigint) AS "downloadCountWeek",
            COALESCE(m."downloadCountMonth", 0::bigint) AS "downloadCountMonth",
            COALESCE(m."downloadCountYear", 0::bigint) AS "downloadCountYear",
            COALESCE(m."downloadCountAllTime", 0::bigint) AS "downloadCountAllTime",
            COALESCE(m."favoriteCountDay", 0::bigint) AS "favoriteCountDay",
            COALESCE(m."favoriteCountWeek", 0::bigint) AS "favoriteCountWeek",
            COALESCE(m."favoriteCountMonth", 0::bigint) AS "favoriteCountMonth",
            COALESCE(m."favoriteCountYear", 0::bigint) AS "favoriteCountYear",
            COALESCE(m."favoriteCountAllTime", 0::bigint) AS "favoriteCountAllTime",
            COALESCE(m."ratingCountDay", 0::bigint) AS "ratingCountDay",
            COALESCE(m."ratingCountWeek", 0::bigint) AS "ratingCountWeek",
            COALESCE(m."ratingCountMonth", 0::bigint) AS "ratingCountMonth",
            COALESCE(m."ratingCountYear", 0::bigint) AS "ratingCountYear",
            COALESCE(m."ratingCountAllTime", 0::bigint) AS "ratingCountAllTime",
            COALESCE(m."ratingDay", 0::double precision) AS "ratingDay",
            COALESCE(m."ratingWeek", 0::double precision) AS "ratingWeek",
            COALESCE(m."ratingMonth", 0::double precision) AS "ratingMonth",
            COALESCE(m."ratingYear", 0::double precision) AS "ratingYear",
            COALESCE(m."ratingAllTime", 0::double precision) AS "ratingAllTime",
            COALESCE(m."thumbsUpCountDay", 0::bigint) AS "thumbsUpCountDay",
            COALESCE(m."thumbsUpCountWeek", 0::bigint) AS "thumbsUpCountWeek",
            COALESCE(m."thumbsUpCountMonth", 0::bigint) AS "thumbsUpCountMonth",
            COALESCE(m."thumbsUpCountYear", 0::bigint) AS "thumbsUpCountYear",
            COALESCE(m."thumbsUpCountAllTime", 0::bigint) AS "thumbsUpCountAllTime",
            u."reactionCountDay",
            u."reactionCountWeek",
            u."reactionCountMonth",
            u."reactionCountYear",
            u."reactionCountAllTime"
           FROM user_counts u
             LEFT JOIN user_model_metrics m ON m."userId" = u."userId"
        )
 SELECT full_user_stats."userId",
    full_user_stats."followerCountDay",
    full_user_stats."followingCountDay",
    full_user_stats."hiddenCountDay",
    full_user_stats."followerCountWeek",
    full_user_stats."followingCountWeek",
    full_user_stats."hiddenCountWeek",
    full_user_stats."followerCountMonth",
    full_user_stats."followingCountMonth",
    full_user_stats."hiddenCountMonth",
    full_user_stats."followerCountYear",
    full_user_stats."followingCountYear",
    full_user_stats."hiddenCountYear",
    full_user_stats."followerCountAllTime",
    full_user_stats."followingCountAllTime",
    full_user_stats."hiddenCountAllTime",
    full_user_stats."uploadCountDay",
    full_user_stats."uploadCountWeek",
    full_user_stats."uploadCountMonth",
    full_user_stats."uploadCountYear",
    full_user_stats."uploadCountAllTime",
    full_user_stats."reviewCountDay",
    full_user_stats."reviewCountWeek",
    full_user_stats."reviewCountMonth",
    full_user_stats."reviewCountYear",
    full_user_stats."reviewCountAllTime",
    full_user_stats."answerCountDay",
    full_user_stats."answerCountWeek",
    full_user_stats."answerCountMonth",
    full_user_stats."answerCountYear",
    full_user_stats."answerCountAllTime",
    full_user_stats."answerAcceptCountDay",
    full_user_stats."answerAcceptCountWeek",
    full_user_stats."answerAcceptCountMonth",
    full_user_stats."answerAcceptCountYear",
    full_user_stats."answerAcceptCountAllTime",
    full_user_stats."downloadCountDay",
    full_user_stats."downloadCountWeek",
    full_user_stats."downloadCountMonth",
    full_user_stats."downloadCountYear",
    full_user_stats."downloadCountAllTime",
    full_user_stats."favoriteCountDay",
    full_user_stats."favoriteCountWeek",
    full_user_stats."favoriteCountMonth",
    full_user_stats."favoriteCountYear",
    full_user_stats."favoriteCountAllTime",
    full_user_stats."ratingCountDay",
    full_user_stats."ratingCountWeek",
    full_user_stats."ratingCountMonth",
    full_user_stats."ratingCountYear",
    full_user_stats."ratingCountAllTime",
    full_user_stats."ratingDay",
    full_user_stats."ratingWeek",
    full_user_stats."ratingMonth",
    full_user_stats."ratingYear",
    full_user_stats."ratingAllTime",
    full_user_stats."thumbsUpCountDay",
    full_user_stats."thumbsUpCountWeek",
    full_user_stats."thumbsUpCountMonth",
    full_user_stats."thumbsUpCountYear",
    full_user_stats."thumbsUpCountAllTime",
    full_user_stats."reactionCountDay",
    full_user_stats."reactionCountWeek",
    full_user_stats."reactionCountMonth",
    full_user_stats."reactionCountYear",
    full_user_stats."reactionCountAllTime"
   FROM full_user_stats;
