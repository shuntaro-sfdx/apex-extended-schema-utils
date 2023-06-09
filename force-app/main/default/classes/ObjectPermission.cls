public with sharing class ObjectPermission {
  private System.Type sObjectType;
  public Field field;

  /**
   * @description Constructor providing object type.
   * @param sObjectType SObject type.
   */
  public ObjectPermission(System.Type sObjectType) {
    if (Schema.getGlobalDescribe().get(sObjectType.toString()) == null) {
      throw new ExceptionMessage.CustomException(ExceptionMessage.MESSAGES.get('ObjectPermissionNotFoundSObject'));
    }
    this.sObjectType = sObjectType;
    this.field = new Field(this);
  }

  /**
   * @description Gets the object permission to access for an executing user.
   * @return Whther the object is accessible.
   * @example
   */
  public Boolean isAccessible() {
    Schema.SObjectType sObjectType = getSObjectType();
    return sObjectType.getDescribe().isAccessible();
  }

  /**
   * @description Gets the object permission to create for an executing user.
   * @return Whther the object is createable.
   * @example
   */
  public Boolean isCreateable() {
    Schema.SObjectType sObjectType = getSObjectType();
    return sObjectType.getDescribe().isCreateable();
  }

  /**
   * @description Gets the object permission to update for an executing user.
   * @return Whther the object is updateable.
   * @example
   */
  public Boolean isUpdateable() {
    Schema.SObjectType sObjectType = getSObjectType();
    return sObjectType.getDescribe().isUpdateable();
  }

  /**
   * @description Gets the object permission to upsert for an executing user.
   * @return Whther the object is upsertable.
   * @example
   */
  public Boolean isUpsertable() {
    return isCreateable() && isUpdateable();
  }

  /**
   * @description Gets the object permission to delete for an executing user.
   * @return Whther the object is deletable.
   * @example
   */
  public Boolean isDeletable() {
    Schema.SObjectType sObjectType = getSObjectType();
    return sObjectType.getDescribe().isDeletable();
  }

  public class Field {
    private ObjectPermission objectPermission;

    public Field(ObjectPermission paramObjectPermission) {
      objectPermission = paramObjectPermission;
    }

    /**
     * @description Gets the field permissions to access for an executing user.
     * @return Map of the field permissions to access for each of fields
     * @example
     */
    public Map<Schema.SObjectField, Boolean> isAccessible() {
      // ObjectPermission objectPermission = new ObjectPermission(objectPermission.sObjectType.toString());
      Map<String, Schema.SObjectField> fieldMap = objectPermission.getFieldMap();
      Map<Schema.SObjectField, Boolean> permissionsToAccess = new Map<Schema.SObjectField, Boolean>();
      for (String fieldFullName : fieldMap.keySet()) {
        permissionsToAccess.put(fieldMap.get(fieldFullName), fieldMap.get(fieldFullName).getDescribe().isAccessible());
      }
      return permissionsToAccess;
    }

    /**
     * @description Gets the field permissions to create for an executing user.
     * @return Map of the field permissions to create for each of fields
     * @example
     */
    public Map<Schema.SObjectField, Boolean> isCreateable() {
      // ObjectPermission objectPermission = new ObjectPermission(objectPermission.sObjectType.toString());
      Map<String, Schema.SObjectField> fieldMap = objectPermission.getFieldMap();
      Map<Schema.SObjectField, Boolean> permissionsToCreate = new Map<Schema.SObjectField, Boolean>();
      for (String fieldFullName : fieldMap.keySet()) {
        permissionsToCreate.put(fieldMap.get(fieldFullName), fieldMap.get(fieldFullName).getDescribe().isCreateable());
      }
      return permissionsToCreate;
    }
    /**
     * @description Gets the field permissions to update for an executing user.
     * @return Map of the field permissions to update for each of fields
     * @example
     */
    public Map<Schema.SObjectField, Boolean> isUpdateable() {
      //  ObjectPermission objectPermission = new ObjectPermission(objectPermission.sObjectType.toString());
      Map<String, Schema.SObjectField> fieldMap = objectPermission.getFieldMap();
      Map<Schema.SObjectField, Boolean> permissionsToUpdate = new Map<Schema.SObjectField, Boolean>();
      for (String fieldFullName : fieldMap.keySet()) {
        permissionsToUpdate.put(fieldMap.get(fieldFullName), fieldMap.get(fieldFullName).getDescribe().isUpdateable());
      }
      return permissionsToUpdate;
    }
    /**
     * @description Gets the field permissions to upsert for an executing user.
     * @return Map of the field permissions to upsert for each of fields
     * @example
     */
    public Map<Schema.SObjectField, Boolean> isUpsertable() {
      // ObjectPermission objectPermission = new ObjectPermission(objectPermission.sObjectType.toString());
      Map<String, Schema.SObjectField> fieldMap = objectPermission.getFieldMap();
      Map<Schema.SObjectField, Boolean> permissionsToUpsert = new Map<Schema.SObjectField, Boolean>();
      for (String fieldFullName : fieldMap.keySet()) {
        Schema.DescribeFieldResult fieldFullNameDescribeResult = fieldMap.get(fieldFullName).getDescribe();
        permissionsToUpsert.put(
          fieldMap.get(fieldFullName),
          fieldFullNameDescribeResult.isCreateable() && fieldFullNameDescribeResult.isUpdateable()
        );
      }
      return permissionsToUpsert;
    }
  }

  private Schema.SObjectType getSObjectType() {
    Schema.SObjectType sObjectType = Schema.getGlobalDescribe().get(sObjectType.toString());
    return sObjectType;
  }

  private Map<String, Schema.SObjectField> getFieldMap() {
    Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe()
      .get(sObjectType.toString())
      .getDescribe()
      .fields.getMap();
    return fieldMap;
  }
}
