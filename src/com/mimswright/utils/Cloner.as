package com.mimswright.util
{
    import flash.utils.ByteArray;

    public class Cloner
    {
        public static function clone(source:Object):* {
            var copy:ByteArray = new ByteArray();
            copy.writeObject(source);
            copy.position = 0;
            return copy.readObject();
        }                    
    }
    
}