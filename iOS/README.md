# iOS app

## Using webTrustBoxes in an IOS app

While our TrustBoxes (our widgets that show TrustScore, stars, reviews, etc.) are designed for websites, they can work just as well in a native mobile app. Using the [WKWebView](https://developer.apple.com/reference/webkit/wkwebview) from the iOS WebKit SDK, the TrustBox can be used to easily show some Trustpilot data in your app.

In this demo app, a TrustBox Mini Carousel has been implemented. The Main.storyboard has been used to lay out the necessary views, while the FirstViewController.swift has been used to hook it all up. Here’s the implementation process:

### Setting up the TrustBox

1. Go to Integrations > TrustBox Library, and select a TrustBox. Then get the code snippets which are in two parts; a `<script>` tag and a `<div>` tag. 

2. In the `<script>` tag is a URL for the TrustBox bootstrap code. This URL is protocol-relative so it doesn't have a defined http: or https:, it just uses whatever the host website uses. That won't work in a native mobile app, so add https: to the URL: https://widget.trustpilot.com/bootstrap/v5/tp.widget.bootstrap.min.js

3. Load the HTML in the webview using the loadHTMLString method:

```java
let trustboxScript = "..."
let trustboxWidget = "..."
trustboxWebView?.loadHTMLString(trustboxScript + trustboxWidget, baseURL: nil)
```

5. The last step is to allow the app to load data from the web. By default, iOS will block requests to arbitrary URLs [[https://developer.apple.com/library/prerelease/content/documentation/General/Reference/InfoPlistKeyReference/Articles/CocoaKeys.html](https://developer.apple.com/library/prerelease/content/documentation/General/Reference/InfoPlistKeyReference/Articles/CocoaKeys.html)]. There are two ways two get around being blocked:

    * Add a NSAppTransportSecurity section and within that, set NSAllowsArbitraryLoads to **YES**

    * Add a NSAppTransportSecurity section and a NSExceptionDomains dictionary. In that dictionary, add the domain **trustpilot.com**

6. Both settings are implemented in this app.

That's it! Now you should have a TrustBox in your app.

Now, make sure your TrustBox looks as good as possible:

1. Disable scrolling in the webview. 

2. Get rid of any bouncing scroll.

3. Disable scroll in the webview’s internal UIScrollView like this:

```java
trustboxWebView?.scrollView.isScrollEnabled = false
````

Add a viewport meta tag to the webview. With this extra little bit of HTML in the webview, we let the renderer know how wide we want the viewport to be. That means the TrustBox can be set to 100% width (take up the full width).

```java
let metaTag = String(format:"<meta name=\"viewport\" content=\"width=%f, shrink-to-fit=YES\">", (trustboxWebView?.frame.width)!)
let trustboxScript = "..."
let trustboxWidget = "..."

trustboxWebView?.loadHTMLString(metaTag + trustboxScript + trustboxWidget, baseURL: nil)
```

### Handling navigation from links in the TrustBox 

Any links in the TrustBox are swallowed by iOS. To handle links being tapped, simply implement [WKWebViewNavigationDelegate](https://developer.apple.com/reference/webkit/wknavigationdelegate).

With this, delegate links can open in Safari or switch to another view in the app. 

## Using our API to customize TrustBoxes

We have a public API that can be used to build custom versions of our TrustBoxes. Essentially the TrustBoxes are built on these APIs. Through the APIs, you can get details about a company on Trustpilot such as their TrustScore, number of reviews, and current star rating. You can also invite customers to write reviews and then display them in your app.

The demo app uses two endpoints on our API, one to get a business unit ([what's a business unit?](https://developers.trustpilot.com/#BusinessUnit)) with details about star rating, TrustScore, etc, and one to get the latest reviews for that business unit. The business unit the app is using is **trustpilot.com **- the business unit id is defined in the configuration.plist file. This is also where the API key is stored.

The API calls are implemented in the [TrustpilotApi.swift](https://github.com/trustpilot/demo-trustbox-nativeapps/blob/master/iOS/TrustBoxInNativeApp/TrustpilotApi.swift) file. The API requests are simple HTTP GET requests, in this case, using the [URLRequest](https://developer.apple.com/reference/foundation/urlrequest). Responses from the API are in JSON which is easily handled in iOS by using [JSONSerialization](https://developer.apple.com/reference/foundation/jsonserialization).

Once you’ve called the API and deserialized the response data, you can unwrap the data and use it in a view. The [SecondViewController.swift](https://github.com/trustpilot/demo-trustbox-nativeapps/blob/master/iOS/TrustBoxInNativeApp/SecondViewController.swift) is an example of that. The JSON data is deserialized to a dictionary with Stringkeys and Any values. You can get a specific value like this:

let stars = dictionary["stars"] as! NSNumber

Since HTTP requests are asynchronous, the TrustpilotApi methods use a callback, which is called when a response comes back. In iOS, this happens on a different thread from the UI. That means that to update the UI with data from the API, use the DispatchQueue to get back on the main thread. It's still a good idea to update the UI asynchronously though, so the app doesn't become unresponsive.

```java
DispatchQueue.main.async {
  self.updateView(...)
}
```

The DispatchQueue is part of [Grand Central Dispatch.](https://developer.apple.com/reference/dispatch)

### Showing reviews

[ReviewPageViewController.swift](https://github.com/trustpilot/demo-trustbox-nativeapps/blob/master/iOS/TrustBoxInNativeApp/RReviewPageViewController.swift) is an example of getting reviews from the API and showing them in a view. The process is the same as above. The reviews’ endpoint on the API can be filtered in a lot of ways. For example to only return 4- and 5-star reviews, latest 10 reviews, reviews with a specific tag, etc.

### Notes & references

To use our APIs you need an API key. You can get this key from your account manager at Trustpilot. Here's an article about [getting started with our APIs](https://support.trustpilot.com/hc/articles/207309867).

API documentation can be found at [developers.trustpilot.com](https://developers.trustpilot.com/).