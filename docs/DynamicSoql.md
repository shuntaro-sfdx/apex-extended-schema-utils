[README](https://github.com/shuntaro-sfdx/apex-extended-schema-utils/blob/v1.0.2/README.md) &frasl; DynamicSoql

## DynamicSoql

### DynamicSoql

Constructor providing object type.

```apex
SIGNATURE

  public DynamicSoql(System.Type sObjectType)

PARAMETERS

  sObjectType

    Description: sObjectType SObject type.

    Type: System.Type

RETURN VALUE


```

### getSelfSObjectRecords

Gets the records of sObjectType.

```apex
SIGNATURE

  public List<SObject> getSelfSObjectRecords(SoqlQueryClause soqlQueryClause)

PARAMETERS

  soqlQueryClause

    Description: soqlQueryClause SoqlQueryClause object to be converted to a soql query string when extracting records.

    Type: SoqlQueryClause

RETURN VALUE

  List<SObject>
```

### getSelfSObjectRecords

Gets the records of sObjectType.

```apex
SIGNATURE

  public List<SObject> getSelfSObjectRecords(List<String> fieldFullNames)

PARAMETERS

  fieldFullNames

    Description: fieldFullNames List of Field API Names

    Type: List<String>

RETURN VALUE

  List<SObject>
```

### getSObjectRecordsOfParent

Gets the parent-records of sObjectType.

```apex
SIGNATURE

  public List<SObject> getSObjectRecordsOfParent(SoqlQueryClause soqlQueryClause)

PARAMETERS

  soqlQueryClause

    Description: soqlQueryClause SoqlQueryClause object to be converted to a soql query string when extracting records.

    Type: SoqlQueryClause

RETURN VALUE

  List<SObject>
```

### getSObjectRecordsOfParent

Gets the parent-records of sObjectType.

```apex
SIGNATURE

  public List<SObject> getSObjectRecordsOfParent(String parentRelationName, List<String> parentFieldFullNames)

PARAMETERS

  parentRelationName

    Description: parentRelationName Parent relation name.

    Type: StringPARAMETERS

  parentFieldFullNames

    Description: parentRelationName Parent relation name.

    Type: List<String>

RETURN VALUE

  List<SObject>
```

### getSObjectRecordsInChild

Gets the child-records of sObjectType.

```apex
SIGNATURE

  public List<SObject> getSObjectRecordsInChild(SoqlQueryClause soqlQueryClause)

PARAMETERS

  soqlQueryClause

    Description: soqlQueryClause SoqlQueryClause object to be converted to a soql query string when extracting records.

    Type: SoqlQueryClause

RETURN VALUE

  List<SObject>
```

### getSObjectRecordsInChild

Gets the child-records of sObjectType.

```apex
SIGNATURE

  public List<SObject> getSObjectRecordsInChild(String childRelationName, List<String> childFieldFullNames)

PARAMETERS

  childRelationName

    Description: childRelationName Relation name of child-object. Example: Accounts, CustomObj__r.

    Type: StringPARAMETERS

  childFieldFullNames

    Description: childRelationName Relation name of child-object. Example: Accounts, CustomObj__r.

    Type: List<String>

RETURN VALUE

  List<SObject>
```

### getSObjectRecords

Gets the records of sObjectType.

```apex
SIGNATURE

  public List<SObject> getSObjectRecords(SoqlQueryClause soqlQueryClause)

PARAMETERS

  soqlQueryClause

    Description: soqlQueryClause SoqlQueryClause object to be converted to a soql query string when extracting records.

    Type: SoqlQueryClause

RETURN VALUE

  List<SObject>
```

### countSObjectRecords

Counts the number of records of sObjectType.

```apex
SIGNATURE

  public List<AggregateResult> countSObjectRecords(SoqlQueryClause soqlQueryClause)

PARAMETERS

  soqlQueryClause

    Description: soqlQueryClause SoqlQueryClause object to be converted to a soql query string when extracting records.

    Type: SoqlQueryClause

RETURN VALUE

  List<AggregateResult>
```

### countSObjectRecords

Counts the number of records of sObjectType

```apex
SIGNATURE

  public List<AggregateResult> countSObjectRecords(List<String> countFieldFullNames)

PARAMETERS

  countFieldFullNames

    Description: groupClause Group clause for SOQL query.

    Type: List<String>

RETURN VALUE

  List<AggregateResult>
```

### getSoqlQuery

```apex
SIGNATURE

  public String getSoqlQuery(SoqlQueryClause soqlQueryClause)

PARAMETERS

  soqlQueryClause

    Description:

    Type: SoqlQueryClause

RETURN VALUE

  String
```
