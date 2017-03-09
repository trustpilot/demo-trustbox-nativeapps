# Android app

## Using a TrustBox for web in an app

While the TrustBoxes (our widgets that show TrustScore, stars, reviews etc.) are designed to be used on web sites they can work just as well in a native mobile app. Using the [WebView](https://developer.android.com/reference/android/webkit/WebView.html) from the webkit SDK the TrustBox can be used to easily show some Trustpilot data in your app.

In this demo app a TrustBox Mini Carousel has been implemented. Using the [fragment_api.xml](app/src/main/res/layout/fragment_api.xml) to lay out the necessary views and the [TrustBoxFragment.java](app/src/main/java/com/trustpilot/trustboxinnativeapp/TrustBoxFragment.java) to hook it all up. The implementation is done in these.

### Setting up the TrustBox

1. Get the code for the TrustBox to implement. There are two parts; a `<script>` tag and a `<div>` tag. Get these code snippets from our business product under Integrations > TrustBoxes.

2. In the `<script>` tag is a URL to the TrustBox bootstrap code. This URL is protocol-relative meaning it doesn't have a defined `http:` or `https:`, it just uses whatever the host web site uses. That won't work in a native mobile app, so add `https:` to the URL: **https**://widget.trustpilot.com/bootstrap/v5/tp.widget.bootstrap.min.js

3. Load the HTML in the web view using the [loadDataWithBaseURL](https://developer.android.com/reference/android/webkit/WebView.html#loadDataWithBaseURL(java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.String)):

  ```java
  // Put the code snippets in variables
  String bootstrap = "<!-- TrustBox script --> ... <!-- End Trustbox script -->";
  String trustBox = "<!-- TrustBox widget - Mini Carousel --> ... <!-- End TrustBox widget -->";

  // Manually enable JavaScript in the web view
  webView.getSettings().setJavaScriptEnabled(true);

  // Load the code snippets in the web view
  webView.loadDataWithBaseURL("https://widget.trustpilot.com",
                  bootstrap + trustBox,
                  "text/html",
                  null,
                  null);
```

  Note the first parameter to the `loadDataWithBaseURL` method. It's the base URL that is used to resolve relative URLs in the view.

  Another gotcha is that JavaScript must be manually enabled in the view. If it's not the TrustBox bootstrap script will not be allowed to execute and the TrustBox can't load.

4. The TrustBox obviously needs to access the network to download the bootstrap script as well as the data to show. Therefore the app needs the internet permission (see the [AndroidManifest.xml](app/src/main/AndroidManifest.xml) file)

**That's it!** You have a TrustBox in your app!
