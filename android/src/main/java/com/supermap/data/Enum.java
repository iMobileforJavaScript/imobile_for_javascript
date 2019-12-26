package com.supermap.data;

/**
 * @author ���ƽ�
 * @version 2.0
 */
import java.lang.reflect.Field;
import java.lang.reflect.Modifier;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;


public abstract class Enum {
    private final int m_value;
    private final int m_ugcValue;
    
    private static boolean m_isCustom;
    
    protected static HashMap<Class<?>, ArrayList<Enum>> m_hashMap = new HashMap<Class<?>, ArrayList<Enum>>();

    /**
     * ��ȡ���͵����Ƽ���
     * ע��������ʵ�ֵĹ淶
     */
    public static final String[] getNames(Class type) {
        if (type == null) {
            return new String[0];
        }

        //����Ƿ�������EnumBase
        if (!Enum.isValidEnumClass(type)) {
            return new String[0];
        }

        ArrayList names = new ArrayList();
        Enum.getEnumNameValueAndEntry(type, names, null, null);
        String[] nameArr = new String[names.size()];
        names.toArray(nameArr);

        return nameArr;
    }

    /**
     * ��ȡö�����͵�ֵ����
     * @param type Class
     * @return int[]
     */
    public static int[] getValues(Class type) {
        if (type == null) {
            return new int[0];
        }

        if (!Enum.isValidEnumClass(type)) {
            return new int[0];
        }

        ArrayList values = new ArrayList();
        Enum.getEnumNameValueAndEntry(type, null, values, null);

        int[] valueArr = new int[values.size()];
        for (int i = 0; i < values.size(); i++) {
            valueArr[i] = Integer.parseInt(values.get(i).toString());
        }
        return valueArr;

    }

    /**
     * ��ȡ���е�ö�ٶ���
     * @param type Class
     * @return Enum[]
     */
    public static Enum[] getEnums(Class type) {
        if (type == null) {
            return new Enum[0];
        }

        if (!Enum.isValidEnumClass(type)) {
            return new Enum[0];
        }

        ArrayList entries = new ArrayList();
        Enum.getEnumNameValueAndEntry(type, null, null, entries);

        Enum[] enums = new Enum[entries.size()];
        entries.toArray(enums);
        return enums;
    }

    /**
     * ����ֵ��ȡö������
     * @param type Class
     * @param value int
     * @return String
     */
    public static String getNameByValue(Class type, int value) {
        ArrayList names = new ArrayList();
        ArrayList values = new ArrayList();
        Enum.getEnumNameValueAndEntry(type, names, values, null);

        Integer valueObject =Integer.valueOf(value);
        if (!values.contains(valueObject)) {
            String message = InternalResource.loadString("ugcValue", InternalResource.GlobalEnumValueIsError, InternalResource.BundleName);
            throw new RuntimeException(message);

        }
        int index = values.indexOf(valueObject);

        return (String) names.get(index);
    }

    /**
     * ����ö�����ƻ�ȡֵ
     * @param type Class
     * @param key String
     * @return int
     */
    public static int getValueByName(Class type, String name) {
        ArrayList names = new ArrayList();
        ArrayList values = new ArrayList();
        Enum.getEnumNameValueAndEntry(type, names, values, null);

        if (!names.contains(name)) {
            String message = InternalResource.loadString("ugcValue", InternalResource.GlobalEnumValueIsError, InternalResource.BundleName);
            throw new RuntimeException(message);

        }
        int index = names.indexOf(name);
        return Integer.parseInt(values.get(index).toString());

    }

    /**
     * ����ö��ֵ��������Ӧ��ö��
     * @param type Class
     * @param value int
     * @return Enum
     */
    public static Enum parse(Class type, int value) {
        ArrayList values = new ArrayList();
        ArrayList entries = new ArrayList();
        Enum.getEnumNameValueAndEntry(type, null, values, entries);

        Integer valueObject = Integer.valueOf(value);
        if (!values.contains(valueObject)) {
            String message = InternalResource.loadString("ugcValue", InternalResource.GlobalEnumValueIsError, InternalResource.BundleName);
            throw new RuntimeException(message);

        }
        int index = values.indexOf(valueObject);
        return (Enum) entries.get(index);

    }

    /**
     * �������ƽ���ö��
     * @param type Class
     * @param name String
     * @return Enum
     */
    public static Enum parse(Class type, String name) {
        if (type == null || name == null) {
            return null;
        }

        ArrayList names = new ArrayList();
        ArrayList entries = new ArrayList();
        Enum.getEnumNameValueAndEntry(type, names, null, entries);

        if (!names.contains(name)) {
            String message = InternalResource.loadString("ugcValue", InternalResource.GlobalEnumValueIsError, InternalResource.BundleName);
            throw new RuntimeException(message);

        }
        int index = names.indexOf(name);
        return (Enum) entries.get(index);

    }

    /**
     * �Ƿ�����ָ��ֵ��ö���ֶ�
     * @param type Class
     * @param value int
     * @return boolean
     */
    public static boolean isDefined(Class type, int value) {
        ArrayList values = new ArrayList();
        Enum.getEnumNameValueAndEntry(type, null, values, null);
        Integer valueObject = Integer.valueOf(value);
        return values.contains(valueObject);
    }

    /**
     * ö���������Ƿ�����ָ�����Ƶ�ö���ֶ�
     * @param type Class
     * @param name String
     * @return boolean
     */
    public static boolean isDefined(Class type, String name) {
        ArrayList names = new ArrayList();
        Enum.getEnumNameValueAndEntry(type, names, null, null);
        return names.contains(name);
    }

    /**
     * ���캯��
     * �����������øú����Գ�ʼ��ö���ֶ�
     * @param value int
     * @param ugcValue int
     */
    protected Enum(int value, int ugcValue) {
        this.m_value = value;
        this.m_ugcValue = ugcValue;
    }


    /**
    * ��ȡö�ٶ�Ӧ��UGCֵ
    * @param e Enum
    * @return int
    */
   protected static final int internalGetUGCValue(Enum e) {
       return e.getUGCValue();
   }

   /**
    * ����UGCֵ��ȡ��Ӧ��ö��
    * ������������
    * @param type Class
    * @param ugcValue int
    * @return Enum
    */
   protected static final Enum internalParseUGCValue(Class type, int ugcValue) {
       return Enum.parseUGCValue(type, ugcValue);
   }

   /**
    * ����UGCValue��ȡö��ֵ
    * �ڲ�ʹ�ã����������
    * @param type Class
    * @param ugcValue int
    * @return Enum
    */
   public static Enum parseUGCValue(Class type, int ugcValue) {
       ArrayList entries = new ArrayList();
       ArrayList values = new ArrayList();
       Enum.getEnumNameValueAndEntry(type, null, values, entries);

       Integer value = Integer.valueOf(ugcValue);
       if (!values.contains(value)) {
           String message = InternalResource.loadString("ugcValue:"+ugcValue, InternalResource.GlobalEnumValueIsError, InternalResource.BundleName);
           throw new RuntimeException(message);
       }
       int index = values.indexOf(value);
       return (Enum) entries.get(index);
   }

    /**
     * �ж��Ƿ�Ϊ��Ч��ö���ֶ�
     * ��Ч��ö�٣�����������ͣ���Ϊpublic static final��
     * @param field Field
     * @param type Class
     * @return boolean
     */
    private static final boolean isValidEnumField(Field field) {
        if (field == null) {
            return false;
        }

        //ö�ټ��ö�ٵ������Ƿ���ö�����ڵ����������ͬ
        Class type = field.getDeclaringClass();
        if (!field.getType().equals(type)) {
            return false;
        }

        //���Ϸ��ķ������η�
        int moidifiers = field.getModifiers();
        if (!Modifier.isPublic(moidifiers) || !Modifier.isStatic(moidifiers) || !Modifier.isFinal(moidifiers)) {
            return false;
        }

        return true;
    }

    /**
     * ��ȡö�������е����ơ�ֵ�������б�
     * ��Щ�б��˳����һһ��Ӧ�ģ����������໥��ѯ
     * ��������ȡĳ���ֵ������null����
     * Ϊ�����Ч�ʣ����ﲻ�����ͼ�飬�ɺ������÷���֤
     * @param type Class
     * @param names ArrayList
     * @param values ArrayList
     * @param entries ArrayList
     */
    private static void getEnumNameValueAndEntry(Class type, ArrayList names, ArrayList values, ArrayList entries) {
        if (type == null) {
            return;
        }

        if (names == null && values == null && entries == null) {
            return;
        }

        //��ȡ�����е��ֶ�
        Field[] fields = type.getFields();
        if (fields == null || fields.length == 0) {
            return;
        }

        //�������о�̬�ֶΣ����ҷ���������ö��ֵ
        int len = fields.length;
        for (int i = 0; i < len; i++) {
            Field field = fields[i];

            //����Ƿ�Ϊ��Ч��ö���ֶ�
            if (!Enum.isValidEnumField(field)) {
                continue;
            }

            //��ȡ���ֶζ�Ӧ��ö��
            Enum e = null;
            try {
               
                e = (Enum) field.get(null);
            } catch (IllegalAccessException ex) {
                continue;
            } catch (IllegalArgumentException ex) {
                continue;
            }
            if (e != null) {
                if (names != null) {
                    names.add(field.getName());
                }
                if (values != null) {
                    Integer value = Integer.valueOf(e.value());
                    values.add(value);
                }
                if (entries != null) {
                    entries.add(e);
                }
            }
        }
        
        // ����m_hashMap�е�ֵ
        if (m_isCustom) {
        	for (Iterator<Map.Entry<Class<?>, ArrayList<Enum>>> i = m_hashMap
        			.entrySet().iterator(); i.hasNext();) {
        		Map.Entry<Class<?>, ArrayList<Enum>> e = i.next();
        		Class<?> tempClass = e.getKey();
        		if (tempClass.getName().equals(type.getName())) {
        			ArrayList<Enum> customEnums = e.getValue();
        			for (int j = 0; j < customEnums.size(); j++) {
        				Enum customEnum = customEnums.get(j);
        				if (names != null) {
							names.add(String.valueOf(customEnum.value()));
						}
        				if (values != null) {
        					values.add(customEnum.value());
						}
        				if (entries != null) {
        					entries.add(customEnum);
						}
        			}
        			break;
        		}
        	}
		}
    }

    /**
     * �Ƿ�Ϊ��Ч��ö����
     * @param type Class
     * @return boolean
     */
    private static boolean isValidEnumClass(Class type) {
        if (type == null) {
            return false;
        }
        if (!(type.getSuperclass().equals(Enum.class))) {
            return false;
        }
        return true;
    }

    /**
     * ��ȡö�ٶ��������
     * @return String
     */
    public final String name() {
        return Enum.getNameByValue(this.getClass(), value());
    }

    /**
     * ��ȡö�ٵ�ֵ
     * @return int
     */
    public final int value() {
        return this.m_value;
    }

    /**
     * ö�ٵ��ַ���
     * ���ö����
     * @return String
     */
    public String toString() {
        return String.valueOf(name());
    }

    /**
     * ����ö��ֵ����Ϊ��̬���ֶΣ����ֱ�ӱȽ����ñ��֪��ö���Ƿ����
     * @param other Object
     * @return boolean
     */
    public final boolean equals(Object other) {
        if(other == null){
            return false;
        }

        if(!this.getClass().equals(other.getClass())){
            return false;
        }

        Enum eOther = (Enum)other;
        if(this.value()!= eOther.value()){
            return false;
        }

        return true;
    }

    /**
     * ��д��equals��������Ӧ��Ӧ����дhashCode
     * @return int
     */
    public final int hashCode() {
        return System.identityHashCode(this);
    }

    /**
     * ��ȡ��ö�ٵ�UGCֵ
     * ���ڲ�ʹ��
     * ĿǰUGCֵ��UGOֵͳһ�ˣ������Ǳ������е�ʵ�ַ�ʽ
     * @return int
     */
    final int getUGCValue() {
        return this.m_ugcValue;
    }
    
    protected void setCustom(boolean value) {
		m_isCustom = value;
	}
}
