# How to get started

Run the following command to clone this repository

```
git clone https://github.com/shuntaro-sfdx/sfdx-apex-doc.git
```

Then, deploy apex util classes to your org.

```
sfdx force:source:deploy -p force-app/main/default/classes -u <your org alias>
```

or install the package via AppExchange clicking the url below:

[https://login.salesforce.com/packaging/installPackage.apexp?p0=04t2t0000008v9m](https://login.salesforce.com/packaging/installPackage.apexp?p0=04t2t0000008v9m)

# Usage

The usages of Apex classes are listed below:

<usage>

- [DynamicSoql](https://github.com/shuntaro-sfdx/apex-extended-schema-utils/blob/v1.0.2/docs/DynamicSoql.md)
- [ExceptionMessage](https://github.com/shuntaro-sfdx/apex-extended-schema-utils/blob/v1.0.2/docs/ExceptionMessage.md)
- [ObjectInfo](https://github.com/shuntaro-sfdx/apex-extended-schema-utils/blob/v1.0.2/docs/ObjectInfo.md)
  - [Field](https://github.com/shuntaro-sfdx/apex-extended-schema-utils/blob/v1.0.2/docs/ObjectInfo.Field.md)
- [ObjectPermission](https://github.com/shuntaro-sfdx/apex-extended-schema-utils/blob/v1.0.2/docs/ObjectPermission.md)
  - [Field](https://github.com/shuntaro-sfdx/apex-extended-schema-utils/blob/v1.0.2/docs/ObjectPermission.Field.md)
- [ObjectRecordType](https://github.com/shuntaro-sfdx/apex-extended-schema-utils/blob/v1.0.2/docs/ObjectRecordType.md)
- [ObjectRelation](https://github.com/shuntaro-sfdx/apex-extended-schema-utils/blob/v1.0.2/docs/ObjectRelation.md)
- [SoqlQueryClause](https://github.com/shuntaro-sfdx/apex-extended-schema-utils/blob/v1.0.2/docs/SoqlQueryClause.md)

</usage>

# Example

## DynamicSoql class

An example of getting self SObject records, equivalent to the following SOQL.

```soql
SELECT Id, Name, AccountSource, Type FROM Account
WEHRE Id != null ORDER BY Name WITH SECURITY_ENFORCED LIMIT 100 OFFSET 5 FOR VIEW
```

```apex
DynamicSoql accountDynamicSoql = new DynamicSoql(Account.class);
soqlQueryClause soqlQueryClause = new SoqlQueryClause();
soqlQueryClause.fieldFullNames = new List<String>{ 'Id', 'Name', 'AccountSource', 'Type' };
soqlQueryClause.whereClause = 'Id != null';
soqlQueryClause.orderClause = 'Name';
soqlQueryClause.withClause = 'SECURITY_ENFORCED';
soqlQueryClause.limitClause = 100;
soqlQUeryClause.offsetClause = 5;
soqlQUeryClause.isForView = true;

List<SObject> records = accountDynamicSoql.getSelfSObjectRecords(soqlQueryClause);
```

An example of getting parent SObject records, equivalent to the following SOQL.

```soql
SELECT Account.Id, Account.Name, Account.LastName FROM Contact
WEHRE Id != null ORDER BY Name WITH SECURITY_ENFORCED LIMIT 100 OFFSET 0 FOR VIEW
```

```apex
DynamicSoql contactDynamicSoql = new DynamicSoql(Contact.class);
SoqlQueryClause soqlQueryClause = new SoqlQueryClause();
soqlQueryClause.fieldFullNames = new List<String>{ 'Id', 'Name', 'LastName' };
soqlQueryClause.whereClause = 'Id != null';
soqlQueryClause.orderClause = 'Name';
soqlQueryClause.withClause = 'SECURITY_ENFORCED';
soqlQueryClause.limitClause = 100;
soqlQUeryClause.offsetClause = 0;
soqlQUeryClause.isForView = true;

SoqlQueryClause parentSoqlQueryClause = new SoqlQueryClause();
parentSoqlQUeryClause.parentRelationName = 'Account';
parentSoqlQueryClause.fieldFullNames = new List<String>{ 'Id', 'Name', 'AccountSource' };

soqlQUeryClause.parentSoqlQueryClauses = new List<SoqlQueryClause>{ parentSoqlQueryClause };
```

An example of getting child SObject records, equivalent to the following SOQL.

```soql
SELECT Id, Name, AccountSource, Type,
(SELECT Id, LastName, AccountId FROM Contacts) FROM Account
WEHRE Id != null ORDER BY Name WITH SECURITY_ENFORCED LIMIT 100 OFFSET 5 FOR VIEW
```

```apex
DynamicSoql accountDynamicSoql = new DynamicSoql(Account.class);
SoqlQueryClause soqlQueryClause = new SoqlQueryClause();
soqlQueryClause.fieldFullNames = new List<String>{ 'Id', 'Name', 'AccountSource', 'Type' };
soqlQueryClause.whereClause = 'Id != null';
soqlQueryClause.orderClause = 'Name';
soqlQueryClause.withClause = 'SECURITY_ENFORCED';
soqlQueryClause.limitClause = 100;
soqlQUeryClause.offsetClause = 5;
soqlQUeryClause.isForView = true;

SoqlQueryClause childSoqlQueryClause = new SoqlQueryClause();
childSoqlQUeryClause.childRelationName = 'Contacts';
childSoqlQueryClause.fieldFullNames = new List<String>{ 'Id', 'LastName', 'AccountId' };
soqlQUeryClause.childSoqlQueryClauses = new List<SoqlQueryClause>{ childSoqlQueryClause };

List<SObject> records = accountDynamicSoql.getSObjectRecordsInChild(soqlQUeryClause);
```

An example of getting all related SObject records that the relation names of parameter soqlQueryClause refer to.

The method getSObjectRecords allow you to get related records including parent and child SObjects. Self => Parent, Self => Child, and Child => Parent are supported.

The execution is equivalent to the following SOQL.

```soql
SELECT Id, Name,
(SELECT Id, Name, AccountId, Account.Id, Account.Name, Account.AccountId FROM Contacts),
(SELECT Id, Name FROM Opportunities) FROM Account
WEHRE Id != null ORDER BY Name WITH SECURITY_ENFORCED LIMIT 100 OFFSET 0 FOR VIEW
```

```apex
DynamicSoql accountDynamicSoql = new DynamicSoql(Account.class);
SoqlQueryClause soqlQueryClause = new SoqlQueryClause();
soqlQueryClause.fieldFullNames = new List<String>{ 'Id', 'Name' };
soqlQueryClause.whereClause = 'Id != null';
soqlQueryClause.orderClause = 'Name';
soqlQueryClause.withClause = 'SECURITY_ENFORCED';
soqlQueryClause.limitClause = 100;
soqlQUeryClause.offsetClause = 0;
soqlQUeryClause.isForView = true;

SoqlQueryClause firstChildSoqlQueryClause = new SoqlQueryClause();
firstChildSoqlQUeryClause.childRelationName = 'Contacts';
firstChildSoqlQueryClause.fieldFullNames = new List<String>{ 'Id', 'Name', 'AccountId' };

SoqlQueryClause secondChildSoqlQueryClause = new SoqlQueryClause();
secondChildSoqlQueryClause.fieldFullNames = new List<String>{ 'Id', 'Name' };
secondChildSoqlQUeryClause.childRelationName = 'Opportunities';

SoqlQueryClause parentSoqlQueryClause = new SoqlQueryClause();
parentSoqlQueryClause.fieldFullNames = new List<String>{ 'Id', 'Name', 'AccountSource' };
parentSoqlQUeryClause.childRelationName = 'Account';
firstChildSoqlQUeryClause.parentSoqlQueryClauses = new List<SoqlQueryClause>{ parentSoqlQueryClause };

soqlQUeryClause.childSoqlQueryClauses = new List<SoqlQueryClause>{
  firstChildSoqlQueryClause,
  secondChildSoqlQueryClause
};

List<SObject> records = accountDynamicSoql.getSObjectRecords(soqlQUeryClause);
```

An example of counting the number of Account records, equivalent to the following SOQL.

```soql
SELECT COUNT(Id) FROM Account WHERE Id != null GROUP BY AccountSource
```

```apex
DynamicSoql accountDynamicSoql = new DynamicSoql(Account.class);
SoqlQueryClause soqlQueryClause = new SoqlQueryClause();
soqlQueryClause.fieldFullNames = new List<String>{ 'AccountSource' };
soqlQueryClause.whereClause = 'Id != null';
soqlQueryClause.countClause = 'Id';
soqlQueryClause.groupClause = 'AccountSource';

List<AggregateResult> numberOfRecords = accountDynamicSoql.countSObjectRecords(soqlQueryClause);
```

## ObjectInfo class

An example of getting the fullName and label of Account object.

```apex
ObjectInfo objectInfo = new ObjectInfo(Account.class);
String objectFullName = objectInfo.getFullName();
String objectLabel = objectInfo.getLabel();
```

An example of getting the fullName and label of all fields on Account object.

```apex
ObjectInfo objectInfo = new ObjectInfo(Account.class);
List<String> fieldFullNames = objectInfo.field.getFullNames();
Map<Schema.SObjectField, String> fieldLabels = objectInfo.field.getLabels();
```

An example of getting the further metadata of fields on Account object, e.g., type, length, scale, precision, ....

```apex
Map<Schema.SObjectField, String> types = objectInfo.field.getTypes();
Map<Schema.SObjectField, Map<String, String>> picklistLabels = objectInfo.field.getPicklistLabels();
Map<Schema.SObjectField, Integer> digits = objectInfo.field.getDigits();
Map<Schema.SObjectField, Integer> lengths = objectInfo.field.getLengths();
Map<Schema.SObjectField, Integer> precisions = objectInfo.field.getPrecisions();
Map<Schema.SObjectField, Integer> scales = objectInfo.field.getScales();
Map<Schema.SObjectField, List<Schema.SObjectType>> referencesTo = objectInfo.field.getReferencesTo();
Map<Schema.SObjectField, Boolean> isExternalId = objectInfo.field.isExternalId();
Map<Schema.SObjectField, Boolean> isRequired = objectInfo.field.isRequired();
Map<Schema.SObjectField, Boolean> isUnique = objectInfo.field.isUnique();
```

## ObjectRelation class

An exmaple of getting all parent-ObjectInfo class mapped to each of child field's Schema.SObjectField objects.

```apex
ObjectRelation objectRelation = new ObjectRelation(Contact.class);
Map<Schema.SobjectField, List<ObjectInfo>> parentObjectInfos = objectRelation.getParentObjectInfos();
```

An exmaple of getting all child-ObjectInfo class mapped to each of child relation names of the parent-object.

```apex
ObjectRelation objectRelation = new ObjectRelation(Account.class);
Map<String, ObjectInfo> childObjectInfos = objectRelation.getChildObjectInfos();
```

## ObjectPermission class

An example of getting permissions on Account object.

```apex
 ObjectPermission objectPermission = new ObjectPermission(Account.class);
Boolean isAccessible = objectPermission.isAccessible();
Boolean isCreateable = objectPermission.isCreateable();
Boolean isUpdateable = objectPermission.isUpdateable();
Boolean isUpsertable = objectPermission.isUpsertable();
Boolean isDeletable = objectPermission.isDeletable();
```

An example of getting all field permissions on Account object.

```apex
ObjectPermission objectPermission = new ObjectPermission(Account.class);
Map<Schema.SObjectField, Boolean> isAccessible = objectPermission.field.isAccessible();
Map<Schema.SObjectField, Boolean> isCreateable = objectPermission.field.isCreateable();
Map<Schema.SObjectField, Boolean> isUpdateable = objectPermission.field.isUpdateable();
Map<Schema.SObjectField, Boolean> isUpsertable = objectPermission.field.isUpsertable();
```

# Salesforce DX Project: Next Steps

Now that you’ve created a Salesforce DX project, what’s next? Here are some documentation resources to get you started.

## How Do You Plan to Deploy Your Changes?

Do you want to deploy a set of changes, or create a self-contained application? Choose a [development model](https://developer.salesforce.com/tools/vscode/en/user-guide/development-models).

## Configure Your Salesforce DX Project

The `sfdx-project.json` file contains useful configuration information for your project. See [Salesforce DX Project Configuration](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_ws_config.htm) in the _Salesforce DX Developer Guide_ for details about this file.

## Read All About It

- [Salesforce Extensions Documentation](https://developer.salesforce.com/tools/vscode/)
- [Salesforce CLI Setup Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm)
- [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_intro.htm)
- [Salesforce CLI Command Reference](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference.htm)
