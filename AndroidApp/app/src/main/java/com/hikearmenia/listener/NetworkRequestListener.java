package com.hikearmenia.listener;

/**
 * Created by Martha on 4/10/2016.
 */

public interface NetworkRequestListener<T> {
    void onResponseReceive(T obj);

    void onError(String message);
}
