public with sharing class SoqlQueryClause {
  public List<String> fieldFullNames;
  public String whereClause;
  public String orderClause;
  public String groupClause;
  public String havingClause;
  public String withClause;
  public Integer limitClause;
  public Integer offsetClause;
  public Boolean isForView;
  public Boolean isForReference;
  public String updateClause;
  public Boolean isForUpdate;
  public List<String> countFieldFullNames;

  public String parentRelationName;
  public List<SoqlQueryClause> parentSoqlQUeryClauses;

  public String childRelationName;
  public List<SoqlQueryClause> childSoqlQueryClauses;
}
