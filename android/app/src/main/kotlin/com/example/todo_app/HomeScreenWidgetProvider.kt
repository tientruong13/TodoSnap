package com.tientruong.todosnap

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider
import android.util.Log
import android.os.Build

class HomeScreenWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.widget_layout).apply {
                val count = widgetData.getInt("count", 0)
                Log.d("HomeScreenWidgetProvider", "Task count: $count") 
                setTextViewText(R.id.tv_counter, "$count")
            }

            // Create an Intent to launch TodaysTasksAndSubTasks activity
            val intent = Intent(context, MainActivity::class.java).apply {
                action = "android.intent.action.VIEW"
                data = Uri.parse("todoapp://todotasks")
            }

            // Create a PendingIntent to launch the activity
            val pendingIntent = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                PendingIntent.getActivity(context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
                } else {
                    PendingIntent.getActivity(context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT)
                }

            // Associate the PendingIntent with the widget
            views.setOnClickPendingIntent(R.id.widget_root, pendingIntent)

            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}