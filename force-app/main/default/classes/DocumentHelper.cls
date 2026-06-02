/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-22-2026
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@namespaceAccessible
public with sharing class DocumentHelper 
{
    private static final String FIELDNAME_ID = 'Id';

    //@namespaceAccessible
    //public static void validateIsPostiveNumberic(String fieldName, List<SObject> oldEntries, List<SObject> newEntries){
//
  //  }

    public static List<SObject> getObjectsNotEqualsTo(List<SObject> objects, String fieldName, object value){
        List<SObject> sObjects = new List<SObject>();
        for(SObject objectEntry : objects){
            if(objectEntry.get(fieldName) != value){
                sObjects.add(objectEntry);
            }
        }
        return sObjects;
    }

    public static List<SObject> getObjectsNotEqualsTo(List<SObject> objects, String fieldName, List<Id> values){
        List<SObject> sObjects = new List<SObject>();
        for(SObject objectEntry : objects){
            if(!values.contains((Id)objectEntry.get(fieldName))){
                sObjects.add(objectEntry);
            }
        }
        return sObjects;
    }

    @namespaceAccessible
    public static Map<Id, List<Id>> mapFromCollectionWithCollectionIdValues(
        String key1,
        String key2,
        List<SObject> incomingList
    ) {
        Map<Id, List<Id>> returnValues = new Map<Id, List<Id>>();
        for (SObject current : incomingList) {
            if (current.get(key1) != null) {
                if (returnValues.keySet().contains((Id) current.get(key1))) {
                    List<Id> existingList = (List<Id>) returnValues.get(
                        (Id) current.get(key1)
                    );
                    existingList.add((Id)current.get(key2));
                    returnValues.put((id) current.get(key1), existingList);
                } else {
                    List<Id> newList = new List<Id>();
                    newList.add((Id)current.get(key2));
                    returnValues.put((id) current.get(key1), newList);
                }
            }
        }
        return returnValues;
    }

    @namespaceAccessible
    public static Map<Id, List<SObject>> mapFromCollectionWithCollectionValues(
        String key,
        List<SObject> incomingList
    ) {
        String objType = getSobjectTypeFromList(incomingList);
        Type listObjType = Type.forName('List<' + objType + '>');
        Type dynamicMapType = Type.forName('Map<Id, List<' + objType + '>>');
        Map<Id, List<SObject>> returnValues = (Map<Id, List<SObject>>) dynamicMapType.newInstance();
        for (SObject current : incomingList) {
            if (current.get(key) != null) {
                if (returnValues.keySet().contains((Id) current.get(key))) {
                    List<SObject> existingList = (List<SObject>) returnValues.get(
                        (Id) current.get(key)
                    );
                    existingList.add(current);
                    returnValues.put((id) current.get(key), existingList);
                } else {
                    List<SObject> newList = (List<SObject>) listObjType.newInstance();
                    newList.add(current);
                    returnValues.put((id) current.get(key), newList);
                }
            }
        }
        return returnValues;
    }

    
    public static SObject getObjectByStringFilter(List<SObject> records, String fieldName, String value)
    {
        for(SObject record : records)
            if(record.get(fieldName) == value)
                return record;

        return null;
    }



    @namespaceAccessible
    public static List<SObject> getModifiedNewObjects(string fieldNameToCheck, List<SObject> oldEntries, List<SObject> newEntries){
        List<SObject> modifiedObjects = new List<SObject>();
        if(newEntries == null || oldEntries==null){
            return modifiedObjects;
            
        }
        Map<Id, SObject> oldObjectsMap = new Map<Id, SObject>(oldEntries);
        for(SObject lineEntry : newEntries){
            SObject oldEntry = oldObjectsMap.get(lineEntry.Id);
            if(oldEntry != null){
                if(oldEntry.get(fieldNameToCheck) != lineEntry.get(fieldNameToCheck)) {                    
                    modifiedObjects.add(lineEntry);
                } 
            }   
        }
        return modifiedObjects;
    }

    @namespaceAccessible
    public static List<Id> getModifiedNewObjectIds(string fieldNameToCheck, String idFieldName, List<SObject> oldEntries, List<SObject> newEntries){
        List<Id> modifiedObjects = new List<Id>();
        if(newEntries == null || oldEntries==null){
            return modifiedObjects;
        }
        Map<Id, SObject> oldObjectsMap = new Map<Id, SObject>(oldEntries);
        for(SObject lineEntry : newEntries){
            SObject oldEntry = oldObjectsMap.get(lineEntry.Id);
            if(oldEntry != null){
                if(oldEntry.get(fieldNameToCheck) != lineEntry.get(fieldNameToCheck)) {                    
                    modifiedObjects.add((Id)lineEntry.get(idFieldName));
                } 
            }   
        }
        return modifiedObjects;
    }

    @namespaceAccessible
    public static List<SObject> getModifiedNewObjects(List<String> fieldNamesToCheck, List<SObject> oldEntries, List<SObject> newEntries){
        List<SObject> modifiedObjects = new List<SObject>();
        if(newEntries == null || oldEntries==null){
            return modifiedObjects;
        }
        Map<Id, SObject> oldObjectsMap = new Map<Id, SObject>(oldEntries);
        for(SObject lineEntry : newEntries){
            SObject oldEntry = oldObjectsMap.get(lineEntry.Id);
            if(oldEntry != null){
                for(String fieldName: fieldNamesToCheck){
                    if(oldEntry.get(fieldName) != lineEntry.get(fieldName)) {                    
                        modifiedObjects.add(lineEntry);
                        break;
                    } 
                }
            }   
        }
        return modifiedObjects;
    }

    @namespaceAccessible
    public static List<Id>getModifiedNewObjectIds (List<String> fieldNamesToCheck, String idFieldName, List<SObject> oldEntries, List<SObject> newEntries){
        List<Id> modifiedObjects = new List<Id>();
        if(newEntries == null || oldEntries==null){
            return modifiedObjects;
        }
        Map<Id, SObject> oldObjectsMap = new Map<Id, SObject>(oldEntries);
        for(SObject lineEntry : newEntries){
            SObject oldEntry = oldObjectsMap.get(lineEntry.Id);
            if(oldEntry != null){
                for(String fieldName: fieldNamesToCheck){
                    if(oldEntry.get(fieldName) != lineEntry.get(fieldName)) {                    
                        modifiedObjects.add((Id)lineEntry.get(idFieldName));
                        break;
                    } 
                }
            }   
        }
        return modifiedObjects;
    }
    
    @namespaceAccessible
    public static List<SObject> getApprovedObjects(String approvalfieldNames, List<SObject> oldEntries, List<SObject> newEntries)
    {
        List<SObject> modifiedObjects = new List<SObject>();
        if(newEntries == null || oldEntries==null){
            return modifiedObjects;
        }
        
        
        Map<Id, SObject> oldObjectsMap = new Map<Id, SObject>(oldEntries);
        for(SObject lineEntry : newEntries){
            SObject oldEntry = oldObjectsMap.get(lineEntry.Id);
            if(oldEntry != null){
                if(oldEntry.get(approvalfieldNames) != lineEntry.get(approvalfieldNames) && ((Boolean)lineEntry.get(approvalfieldNames))) {                    
                    modifiedObjects.add(lineEntry);
                } 
            }   
        }
        return modifiedObjects;
    }

    @namespaceAccessible
    public static List<SObject> getApprovedNewObjects(String approvalfieldNames, List<SObject> newEntries){
        List<SObject> modifiedObjects = new List<SObject>();
        if(newEntries == null){
            return modifiedObjects;
        }
        for(SObject lineEntry : newEntries){
            if((Boolean)lineEntry.get(approvalfieldNames)) {
                modifiedObjects.add(lineEntry);
                //break;
            } 
        }
        return modifiedObjects;
    }

    @namespaceAccessible
    public static SObject getObject(List<SObject> objects, Id objectId)
    {
        for(SObject objectEntry : objects){
            if(objectEntry.Id == objectId){
                return objectEntry;
            }
        }
        return null;
    }

    @namespaceAccessible
    public static List<SObject> getObjects(List<SObject> objects, String idFieldName, Id objectId)
    {
        List<SObject> sObjects = new List<SObject>();
        for(SObject objectEntry : objects){
            if(objectEntry.get(idFieldName) == objectId){
                sObjects.add(objectEntry);
            }
        }
        return sObjects;
    }

    @namespaceAccessible
    public static SObject getObjectByFilter(List<SObject> objects, String fieldName, object value){
        for(SObject objectEntry : objects){
            if(objectEntry.get(fieldName) == value){
               return objectEntry;
            }
        }
        return null;
    }
   

    @namespaceAccessible
    public static List<SObject> getObjectsByFilter(List<SObject> objects, Map<String, Object> filterValues)
    {
        List<SObject> sObjects = new List<SObject>();
        for(SObject objectEntry : objects)
        {
            Integer matchCount = 0;
            for(String filterKey : filterValues.keySet())
            {
                if(filterKey.contains('.'))
                {
                    List<String> keyFields = filterKey.split('.');
                    if(keyFields.size() > 0)
                    {
                        SObject relatedRecord = (SObject)objectEntry.GetsObject(keyFields[0]);
                        if(relatedRecord != null && relatedRecord.get(keyFields[1]) == filterValues.get(filterKey))
                            matchCount = matchCount + 1;
                    }
                }
                if(objectEntry.get(filterKey) == filterValues.get(filterKey))
                    matchCount = matchCount + 1;
            }
            if(matchCount == filterValues.keySet().size())
                sObjects.add(objectEntry); 
        }
        return sObjects;
    }

    @namespaceAccessible
    public static List<SObject> getObjectsByAnyOneFilter(List<SObject> objects, Map<String, Object> filterValues)
    {
        List<SObject> sObjects = new List<SObject>();
        for(SObject objectEntry : objects)
        {
            Integer matchCount = 0;
            for(String filterKey : filterValues.keySet())
            {
                if(filterKey.contains('.'))
                {
                    List<String> keyFields = filterKey.split('.');
                    if(keyFields.size() > 0)
                    {
                        SObject relatedRecord = (SObject)objectEntry.GetsObject(keyFields[0]);
                        if(relatedRecord != null && relatedRecord.get(keyFields[1]) == filterValues.get(filterKey))
                            matchCount = matchCount + 1;
                    }
                }
                if(objectEntry.get(filterKey) == filterValues.get(filterKey))
                    matchCount = matchCount + 1;
            }
            if(matchCount > 0)
                sObjects.add(objectEntry); 
        }
        return sObjects;
    }

    @namespaceAccessible
    public static List<SObject> getObjectsByFilter(List<SObject> objects, String fieldName, object value){
        List<SObject> sObjects = new List<SObject>();
        for(SObject objectEntry : objects){
            if(objectEntry.get(fieldName) == value){
                sObjects.add(objectEntry);
            }
        }
        return sObjects;
    }

    @namespaceAccessible
    public static List<SObject> getObjectsByFilter(List<SObject> objects, String relatedObjectName, String fieldName, object value){
        List<SObject> sObjects = new List<SObject>();
        for(SObject objectEntry : objects){
            SObject relatedObject = objectEntry.getSObject(relatedObjectName);
            if(relatedObject != null && relatedObject.get(fieldName) == value){
                sObjects.add(objectEntry);
            }
        }
        return sObjects;
    }

    @namespaceAccessible
    public static List<SObject> getObjectsWithNotNull(List<SObject> objects, String fieldName){
        List<SObject> sObjects = new List<SObject>();
        for(SObject objectEntry : objects){
            if(objectEntry.get(fieldName) != null){
                sObjects.add(objectEntry);
            }
        }
        return sObjects;
    }

    @namespaceAccessible
    public static List<SObject> getObjectsWithNull(List<SObject> objects, String fieldName){
        List<SObject> sObjects = new List<SObject>();
        for(SObject objectEntry : objects){
            if(objectEntry.get(fieldName) == null){
                sObjects.add(objectEntry);
            }
        }
        return sObjects;
    }

    @namespaceAccessible
    public static List<ID> extractIds(List<SObject> records)
    {
        List<ID> resultIds = new List<ID>();
        for(SObject record : records){
            if(record.get(FIELDNAME_ID) != null && !resultIds.contains((ID)record.get(FIELDNAME_ID))){
                resultIds.Add((ID)record.get(FIELDNAME_ID));
            }
        }
        return resultIds;
    }

    @namespaceAccessible
    public static List<ID> extractIds(List<SObject> records, string fieldName)
    {
        List<ID> resultIds = new List<ID>();
        for(SObject record : records){
            if(record.get(fieldName) != null && !resultIds.contains((ID)record.get(fieldName))){
                resultIds.Add((ID)record.get(fieldName));
            }
        }
        return resultIds;
    }

    @namespaceAccessible
    public static List<ID> extractIds(List<SObject> records, string relationshipName, string fieldName)
    {
        List<ID> resultIds = new List<ID>();
        for(SObject record : records){
            List<SObject> relatedRecords = (List<SObject>)record.getSObjects(relationshipName);
            if(relatedRecords !=null && relatedRecords.size() > 0){
                for(SObject relatedRecord : relatedRecords){
                    if(relatedRecord.get(fieldName) != null 
                        && !resultIds.contains((ID)relatedRecord.get(fieldName))){
                        resultIds.Add((ID)relatedRecord.get(fieldName));
                    }
                }
            }
        }
        return resultIds;
    }

    @namespaceAccessible
    public static List<ID> extractIdsFromLookup(List<SObject> records, string lookupFieldReference, string fieldName)
    {
        List<ID> resultIds = new List<ID>();
        for(SObject record : records){
            SObject relatedRecord = (SObject)record.GetsObject(lookupFieldReference);
            if(relatedRecord !=null){
                if(relatedRecord.get(fieldName) != null)
                    resultIds.Add((ID)relatedRecord.get(fieldName));
            }
        }
        return resultIds;
    }

    @namespaceAccessible
    public static List<String> extractStringFromLookup(List<SObject> records, string lookupFieldReference, string fieldName)
    {
        List<String> results = new List<String>();
        for(SObject record : records){
            SObject relatedRecord = (SObject)record.GetsObject(lookupFieldReference);
            if(relatedRecord !=null){
                if(relatedRecord.get(fieldName) != null)
                    results.Add((String)relatedRecord.get(fieldName));
            }
        }
        return results;
    }

    @namespaceAccessible
    public static List<Object> extractUniqueValues(List<SObject> records, string fieldName)
    {
        List<Object> results = new List<Object>();
        for(SObject record : records){
            if(record.get(fieldName) != null && !results.contains(record.get(fieldName))){
                results.Add(record.get(fieldName));
            }
        }
        return results;
    }
    
    public static List<String> extractUniqueValues1(List<SObject> records, string fieldName)
    {
        List<String> results = new List<String>();
        for(SObject record : records){
            if(record.get(fieldName) != null && !results.contains((String)record.get(fieldName))){
                results.Add((String)record.get(fieldName));
            }
        }
        return results;
    }

    @namespaceAccessible
    public static List<Integer> extractUniqueIntegerValues(List<SObject> records, string fieldName)
    {
        List<Integer> results = new List<Integer>();
        for(SObject record : records){
            if(record.get(fieldName) != null && !results.contains(Integer.valueOf(record.get(fieldName)))){
                results.Add(Integer.valueOf(record.get(fieldName)));
            }
        }
        return results;
    }

    @namespaceAccessible
    public static List<Date> extractUniqueDateValues(List<SObject> records, string fieldName)
    {
        List<Date> results = new List<Date>();
        for(SObject record : records){
            if(record.get(fieldName) != null && !results.contains((Date)record.get(fieldName))){
                results.Add((Date)record.get(fieldName));
            }
        }
        return results;
    }

    @namespaceAccessible
    public static List<String> extractStringValues(List<SObject> records, string fieldName)
    {
        List<String> resultIds = new List<String>();
        for(SObject record : records){
            if(record.get(fieldName) != null && !resultIds.contains(String.valueOf(record.get(fieldName)))){
                resultIds.Add( String.valueOf(record.get(fieldName)));
            }
        }
        return resultIds;
    }

    @namespaceAccessible
    public static Map<ID, List<SObject>> mapLinesWithDocument(List<ID> documentIds, string documentIdFieldNameInLines, List<SObject> lines)
    {
        Map<ID, List<SObject>> result = new Map<ID, List<SObject>>();
        for(ID objectId : documentIds){
            List<SObject> internalResult = new List<SObject>();
            for(SObject record : lines){
                if((ID)record.get(documentIdFieldNameInLines) == objectId){
                    internalResult.Add(record);
                }
            }
            result.put(objectId, internalResult);
        }
        return result;
    }

    @namespaceAccessible
    public static Double getTotal(List<SObject> records, string fieldName)
    {
        Double result = 0;
        for(SObject record : records)
        {
            if(record.get(fieldName) != null)
            {
                result = (Double)result + Double.valueOf((Double)record.get(fieldName));
            }
        }
        return (Double)result;
    }

    private static String getSobjectTypeFromList(List<SObject> incomingList) {
        return (!incomingList.isEmpty())
            ? String.valueOf(incomingList[0]?.getSObjectType())
            : 'sObject';
    }
}