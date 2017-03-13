# Android app

## Using a TrustBox for web in an app

While the TrustBoxes (our widgets that show TrustScore, stars, reviews etc.) are designed to be used on web sites they can work just as well in a native mobile app. Using the [WebView](https://developer.android.com/reference/android/webkit/WebView.html) from the webkit SDK the TrustBox can be used to easily show some Trustpilot data in your app.

In this demo app a TrustBox Mini Carousel has been implemented. Using the [fragment_api.xml](app/src/main/res/layout/fragment_api.xml) to lay out the necessary views and the [TrustBoxFragment.java](app/src/main/java/com/trustpilot/trustboxinnativeapp/TrustBoxFragment.java) to hook it all up.

### Setting up the TrustBox

1. Get the code for the TrustBox to implement. There are two parts; a `<script>` tag and a `<div>` tag. See [how to choose a TrustBox](https://support.trustpilot.com/hc/articles/204123713) in our support center


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

  JavaScript must be manually enabled in the view. If it's not the TrustBox bootstrap script will not be allowed to execute and the TrustBox can't load.

4. The TrustBox obviously needs to access the network to download the bootstrap script as well as the data to show. Therefore the app needs the internet permission (see the [AndroidManifest.xml](app/src/main/AndroidManifest.xml) file)

**That's it!** You have a TrustBox in your app!


## Using the Trustpilot API

We have a public API that can be used to build custom versions of the TrustBoxes. Essentially the TrustBoxes are built on these APIs. Through the APIs you can get details about a company on Trustpilot such as their TrustScore, number of reviews and current star rating. You can also request reviews that can then be displayed in your app.

The demo app uses two endpoints on our API, one to get a business unit ([what's a business unit?](https://developers.trustpilot.com/#BusinessUnit)) with details about star rating, TrustScore etc, and one to get the latest reviews for that business unit. The business unit the app is using is trustpilot.com - the business unit id is hard coded in the API call in this demo app. So is the API key.

The demo API call is implemented in the [ApiFragment.java](app/src/main/java/com/trustpilot/trustboxinnativeapp/ApiFragment.java) file. The API request is a simple HTTP GET request, in this case done by using [Volley](https://developer.android.com/training/volley/index.html) - an HTTP library for Android apps. Responses from the API are in JSON which is easily handled in Volley by using the [JsonObjectRequest](https://github.com/google/volley/blob/master/src/main/java/com/android/volley/toolbox/JsonObjectRequest.java) class to send the request.

All that is left after calling the API and deserializing the response data is unwrapping the data and using it in a view. The response object from JsonObjectRequest is a JSONObject that has methods to get data in the appropriate data type:

```java
// response is of type JSONObject
int stars = response.getInt("stars");
double score = response.getDouble("trustScore");

// getting a child object and then a property on that object
JSONObject reviews = response.getJSONObject("numberOfReviews");
int total = reviews.getInt("total");
```

After unwrapping all the necessary data all that's left is updating the view to show it.

Sending the Volley JsonObjectRequest takes a bit of code. This demo app's simple approach is not generic or reusable but it's enough for this demonstration.

```java
JsonObjectRequest apiRequest = new JsonObjectRequest(...);

Cache cache = new DiskBasedCache(this.getContext().getCacheDir(), 0);
Network network = new BasicNetwork(new HurlStack());
RequestQueue queue = new RequestQueue(cache, network);
queue.start();
queue.add(apiRequest);
```


### Showing reviews

To get reviews from the API and show them is similar to getting business unit data. It's just a matter of requesting a different endpoint. The endpoint to use is [https://api.trustpilot.com/v1/business-units/[BUSINESS_UNIT_ID]/reviews](https://developers.trustpilot.com/business-unit-api#get-a-business-unit's-reviews). The reviews endpoint on the API can be filtered in a lot of ways. For example to only return 4- and 5-star reviews, latest 5 reviews, reviews with a specific tag etc.


### Notes & references

To use our APIs you need an API key. You can get this key from your account manager at Trustpilot. Here's an article about [getting started with our APIs](https://support.trustpilot.com/hc/articles/207309867).

API documentation can be found at [developers.trustpilot.com](https://developers.trustpilot.com/)
