package com.trustpilot.trustboxinnativeapp;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.webkit.WebView;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);


        String bootstrap = "<!-- TrustBox script --> <script type=\"text/javascript\" src=\"https://widget.trustpilot.com/bootstrap/v5/tp.widget.bootstrap.min.js\" async></script> <!-- End Trustbox script -->";
        String trustBox = "<!-- TrustBox widget - Mini Carousel --> <div class=\"trustpilot-widget\" data-locale=\"en-US\" data-template-id=\"539ad0ffdec7e10e686debd7\" data-businessunit-id=\"55be5d980000ff000581b3e6\" data-style-height=\"350px\" data-style-width=\"100%\" data-theme=\"light\" data-stars=\"1,2,3,4,5\"> <a href=\"https://www.trustpilot.com/review/revelsystems.com\" target=\"_blank\">Trustpilot</a> </div> <!-- End TrustBox widget -->";


        WebView webView = (WebView)findViewById(R.id.trustbox_view);
        webView.getSettings().setJavaScriptEnabled(true);
        webView.loadDataWithBaseURL(
                "https://widget.trustpilot.com",
                bootstrap + trustBox,
                "text/html",
                null,
                "https://widget.trustpilot.com");
    }
}
