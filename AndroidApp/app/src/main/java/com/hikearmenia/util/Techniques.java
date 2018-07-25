package com.hikearmenia.util;


public enum Techniques {

    Pulse(PulseAnimator.class),
    /*SlideInLeft(SlideInLeftAnimator.class),
    SlideInRight(SlideInRightAnimator.class),*/
    FadeInUp(FadeInUpAnimator.class);


    private Class animatorClazz;

    private Techniques(Class clazz) {
        animatorClazz = clazz;
    }

    public BaseViewAnimator getAnimator() {
        try {
            return (BaseViewAnimator) animatorClazz.newInstance();
        } catch (Exception e) {
            throw new Error("Can not init animatorClazz instance");
        }
    }
}