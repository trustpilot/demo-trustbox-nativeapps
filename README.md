# Using TrustBoxes in native apps

While our TrustBoxes are designed for websites, they work just as well in native mobile apps. Here’s an implementation guide for IOS and Android apps, including examples of  how to use the TrustBoxes for web and how to build a custom integration with Trustpilot’s API.

## TrustBox design

Trustpilot’s TrustBoxes are designed for websites, and the implementation is therefore based on copy/pasting an HTML `<script>` tag that loads the TrustBox functionality and a `<div>` that defines the parameters of the TrustBox. But they can be used fairly easily in a native mobile app by using the platforms' web view controls.

See guides and specific implementation details in the sub folders here:

* [iOS app](https://github.com/trustpilot/demo-trustbox-nativeapps/tree/master/iOS)

* [Android app](https://github.com/trustpilot/demo-trustbox-nativeapps/tree/master/Android)

The TrustBoxes can be found in Trustpilot Business - [Integrations.](https://businessapp.b2b.trustpilot.com/#/integrations/trustbox/library)

## Using our API to customize TrustBoxes

We have a public API that can be used to build custom versions of our TrustBoxes. Essentially the TrustBoxes are built on these APIs. Through the APIs, you can get details about a company on Trustpilot such as their TrustScore, number of reviews, and current star rating. You can also invite customers to write reviews and then display them in your app.

To use our APIs, you need an API key. You can get this key from your account manager at Trustpilot. Here's an article about [getting started with our APIs](https://support.trustpilot.com/hc/articles/207309867).

API documentation can be found at [developers.trustpilot.com.](https://developers.trustpilot.com/)

The two demo apps in the repository use an API to show a company's stars, etc. See the specific implementations here:

* [iOS app](https://github.com/trustpilot/demo-trustbox-nativeapps/blob/master/iOS)

* [Android app](https://github.com/trustpilot/demo-trustbox-nativeapps/blob/master/Android)
