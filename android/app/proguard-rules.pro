# Keep Hive and its internal classes
-keep class io.hivedb.** { *; }
-keepnames class io.hivedb.** { *; }
-keep @interface io.hive.HiveType
-keep @interface io.hive.HiveField
-keep class * extends io.hivedb.TypeAdapter

# IMPORTANT: Keep your own data models
# Replace 'your.package.name' with your actual app package name
-keep class com.app.dailyhabits.models.** { *; }

# Flutter Local Notifications rules
-keep class com.dexterous.flutterlocalnotifications.** { *; }
-keep class com.google.gson.** { *; }
-keep class com.google.crypto.tink.** { *; }
-keep public class com.google.gson.reflect.TypeToken
-keep class * extends com.google.gson.TypeAdapter
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer