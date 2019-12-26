package com.supermap.data;

/**
 * <p>Title: </p>
 *
 * <p>Description: </p>
 *
 * <p>Copyright: Copyright (c) 2007</p>
 *
 * <p>Company: SuperMap GIS Technologies Inc.</p>
 *
 * @author not attributable
 * @version 2.0
 */
public abstract class InternalHandleDisposable extends InternalHandle implements
        IDisposable {
    protected InternalHandleDisposable() {
    }

    /**
     * 如果设置Handle请调用setHandle(long handle, boolean disposable)
     * 该函数只用于dispose方法的时候设置handle为0
     * @param handle long
     */
    protected void setHandle(long handle) {
        if (handle != 0) {
            String message = InternalResource.loadString("setHandle()",
                    InternalResource.HandleDisposableCantCreate,
                    InternalResource.BundleName);
            throw new UnsupportedOperationException(message);
        }
        //设置基类的为0
        super.setHandle(0);
    }

    /**
     * 设置对象的指针
     * 该函数内部使用
     * 1.之前对象为空，设置成功
     * 2.之前对象为可释放，且尚未释放，设置其为Handle抛出异常
     * 3.之前对象为可释放，且已经释放，能设置成功
     */
    protected void setHandle(long handle, boolean disposable) {
        if (this.getIsDisposable() && !(getHandle() == 0)) {
            String message = InternalResource.loadString("setHandle()",
                    InternalResource.HandleOriginalObjectHasNotBeenDisposed,
                    InternalResource.BundleName);
            throw new IllegalStateException(message);
        }
        this.setIsDisposable(disposable);
        super.setHandle(handle);
    }

    /**
     * 对象是否能释放
     * @return boolean
     */
    protected boolean getIsDisposable() {
        return this.m_disposable;
    }

    protected void finalize() {
        if (this.getIsDisposable() && !(getHandle() == 0)) {
//这个时机没准,在这里释放会出现野指针崩溃,需要在其他地方维护 add by huangkj 2015-11-9		
//            dispose();
        }
    }

    /**
     * 设置对象是否能被释放
     * 1.之前对象为空，设置成功
     * 2.之前对象为可释放，且尚未释放，设置其为false抛出异常
     * 3.之前对象为可释放，且已经释放，能设置其值为true/false
     * 4.之前对象不可释放，设置其为true抛出异常
     */
    protected void setIsDisposable(boolean disposable) {
        this.m_disposable = disposable;
    }


    protected static void setIsDisposable(InternalHandleDisposable obj,
                                          boolean disposable) {
        obj.setIsDisposable(disposable);
    }

    private boolean m_disposable = true;
}
