package com.trustpilot.trustboxinnativeapp;

import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.content.res.ResourcesCompat;
import android.support.v7.view.ContextThemeWrapper;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;


public class ApiFragment extends Fragment {
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View rootView = inflater.inflate(R.layout.fragment_api, container, false);
        return rootView;
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);

        ImageView imageView = (ImageView)this.getActivity().findViewById(R.id.starsImageView);

        final ContextThemeWrapper wrapper = new ContextThemeWrapper(this.getActivity(), R.style.Stars3);
        final Drawable drawable = ResourcesCompat.getDrawable(getResources(), R.drawable.stars, wrapper.getTheme());
        imageView.setImageDrawable(drawable);
    }
}
