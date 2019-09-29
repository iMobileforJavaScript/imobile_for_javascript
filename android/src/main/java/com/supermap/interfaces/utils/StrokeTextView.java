package com.supermap.interfaces.utils;

import android.support.v7.widget.AppCompatTextView;
import android.widget.TextView;
import android.content.Context;
import android.util.AttributeSet;
import android.view.ViewGroup;
import android.text.TextPaint;
import android.graphics.Paint.Style;
import android.graphics.Color;
import android.graphics.Canvas;


public class StrokeTextView extends AppCompatTextView
{
    private TextView outlineTextView = null;
    private int strokeWidth =  2;
    public StrokeTextView(Context context)
    {
        super(context);

        outlineTextView = new TextView(context);
        init();
    }

    public StrokeTextView(Context context, AttributeSet attrs)
    {
        super(context, attrs);

        outlineTextView = new TextView(context, attrs);
        init();
    }

    public StrokeTextView(Context context, AttributeSet attrs, int defStyle)
    {
        super(context, attrs, defStyle);

        outlineTextView = new TextView(context, attrs, defStyle);
        init();
    }

    public void init()
    {
        TextPaint paint = outlineTextView.getPaint();
        paint.setStrokeWidth(strokeWidth);// 描边宽度
        paint.setStyle(Style.STROKE);
        outlineTextView.setTextColor(Color.BLACK);// 描边颜色
        outlineTextView.setGravity(getGravity());
    }

    @Override
    public  void setTextSize(float size){
        super.setTextSize(size);
        outlineTextView.setTextSize(size);
    }

    @Override
    public void setLayoutParams (ViewGroup.LayoutParams params)
    {
        super.setLayoutParams(params);
        outlineTextView.setLayoutParams(params);
    }

    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec)
    {
        super.onMeasure(widthMeasureSpec, heightMeasureSpec);

        // 设置轮廓文字
        CharSequence outlineText = outlineTextView.getText();
        if (outlineText == null || !outlineText.equals(this.getText()))
        {
            outlineTextView.setText(getText());
            postInvalidate();
        }
        outlineTextView.measure(widthMeasureSpec, heightMeasureSpec);
    }

    @Override
    protected void onLayout (boolean changed, int left, int top, int right, int bottom)
    {
        super.onLayout(changed, left, top, right, bottom);
        outlineTextView.layout(left, top, right, bottom);
    }

    @Override
    protected void onDraw(Canvas canvas)
    {
        outlineTextView.draw(canvas);
        super.onDraw(canvas);
    }
}
