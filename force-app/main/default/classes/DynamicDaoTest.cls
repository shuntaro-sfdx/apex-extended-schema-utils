@isTest(SeeAllData=false)
public with sharing class DynamicDaoTest {
  @isTest
  private static void testGetSelfSObjectRecords() {
    List<Account> accounts = new List<Account>();
    for (Integer index = 0; index < 10; index++) {
      Account acc = new Account();
      acc.Name = 'Name' + index;
      acc.AccountSource = 'Web';
      acc.Type = 'Prospect';
      accounts.add(acc);
    }
    insert accounts;

    DynamicDao accountDynamicDao = new DynamicDao(Account.class);
    SoqlQueryClause soqlQueryClause = new SoqlQueryClause();
    soqlQueryClause.fieldFullNames = new List<String>{ 'Id', 'Name', 'AccountSource', 'Type' };
    soqlQueryClause.whereClause = 'Id != null';
    soqlQueryClause.orderClause = 'Name';
    soqlQueryClause.withClause = 'SECURITY_ENFORCED';
    soqlQueryClause.limitClause = 100;
    soqlQUeryClause.offsetClause = 5;
    soqlQUeryClause.isForView = true;

    List<SObject> records = accountDynamicDao.getSelfSObjectRecords(soqlQueryClause);
    System.assertEquals(accounts.size() - soqlQUeryClause.offsetClause, records.size(), 'Failed to get records.');
  }

  @isTest
  private static void testGetSelfSObjectRecordsWithOnlyFieldFullNames() {
    List<Account> accounts = new List<Account>();
    for (Integer index = 0; index < 10; index++) {
      Account acc = new Account();
      acc.Name = 'Name' + index;
      acc.AccountSource = 'Web';
      acc.Type = 'Prospect';
      accounts.add(acc);
    }
    insert accounts;

    DynamicDao accountDynamicDao = new DynamicDao(Account.class);
    List<String> fieldFullNames = new List<String>{ 'Id', 'Name', 'AccountSource', 'Type' };

    List<SObject> records = accountDynamicDao.getSelfSObjectRecords(fieldFullNames);
    System.assertEquals(accounts.size(), records.size(), 'Failed to get records.');
  }

  @isTest
  private static void testGetSObjectRecordsInChild() {
    Account acc = new Account();
    acc.Name = 'Name';
    acc.AccountSource = 'Web';
    acc.Type = 'Prospect';
    insert acc;

    List<Contact> contacts = new List<Contact>();
    for (Integer index = 0; index < 10; index++) {
      Contact con = new Contact();
      con.LastName = 'Name' + index;
      con.accountId = acc.Id;
      Contacts.add(con);
    }
    insert contacts;

    DynamicDao accountDynamicDao = new DynamicDao(Account.class);
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

    List<SObject> records = accountDynamicDao.getSObjectRecordsInChild(soqlQUeryClause);

    for (Account record : (List<Account>) records) {
      for (Contact childRecord : record.Contacts) {
        System.assertEquals(acc.Id, childRecord.AccountId, 'Failed to get child-records.');
      }
    }
  }

  @isTest
  private static void testGetSObjectRecordsInChildWithOnlyFieldFullnames() {
    Account acc = new Account();
    acc.Name = 'Name';
    acc.AccountSource = 'Web';
    acc.Type = 'Prospect';
    insert acc;

    List<Contact> contacts = new List<Contact>();
    for (Integer index = 0; index < 10; index++) {
      Contact con = new Contact();
      con.LastName = 'Name' + index;
      con.accountId = acc.Id;
      Contacts.add(con);
    }
    insert contacts;

    DynamicDao accountDynamicDao = new DynamicDao(Account.class);
    String childRelationName = 'Contacts';
    List<String> fieldFullNames = new List<String>{ 'Id', 'LastName', 'AccountId' };

    List<SObject> records = accountDynamicDao.getSObjectRecordsInChild(childRelationName, fieldFullNames);

    for (Account record : (List<Account>) records) {
      for (Contact childRecord : record.Contacts) {
        System.assertEquals(acc.Id, childRecord.AccountId, 'Failed to get child-records.');
      }
    }
  }

  @isTest
  private static void testGetSObjectRecordsOfParent() {
    Account acc = new Account();
    acc.Name = 'Name';
    acc.AccountSource = 'Web';
    acc.Type = 'Prospect';
    insert acc;

    List<Contact> contacts = new List<Contact>();
    for (Integer index = 0; index < 10; index++) {
      Contact con = new Contact();
      con.LastName = 'Name' + index;
      con.accountId = acc.Id;
      Contacts.add(con);
    }
    insert contacts;

    DynamicDao contactDynamicDao = new DynamicDao(Contact.class);
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

    List<SObject> records = contactDynamicDao.getSObjectRecordsOfParent(soqlQUeryClause);

    for (Contact record : (List<Contact>) records) {
      System.assertEquals(acc.Id, record.Account.Id, 'Failed to get parent-records.');
    }
  }

  @isTest
  private static void testGetSObjectRecordsOfParentWithOnlyFieldFullNames() {
    Account acc = new Account();
    acc.Name = 'Name';
    acc.AccountSource = 'Web';
    acc.Type = 'Prospect';
    insert acc;

    List<Contact> contacts = new List<Contact>();
    for (Integer index = 0; index < 10; index++) {
      Contact con = new Contact();
      con.LastName = 'Name' + index;
      con.accountId = acc.Id;
      Contacts.add(con);
    }
    insert contacts;

    DynamicDao contactDynamicDao = new DynamicDao(Contact.class);
    String parentRelationName = 'Account';
    List<String> fieldFullNames = new List<String>{ 'Id', 'Name', 'AccountSource' };
    List<SObject> records = contactDynamicDao.getSObjectRecordsOfParent(parentRelationName, fieldFullNames);

    for (Contact record : (List<Contact>) records) {
      System.assertEquals(acc.Id, record.Account.Id, 'Failed to get parent-records.');
    }
  }

  @isTest
  private static void testGetSObjectRecords() {
    Account acc = new Account();
    acc.Name = 'Name';
    acc.AccountSource = 'Web';
    acc.Type = 'Prospect';
    insert acc;

    List<Contact> contacts = new List<Contact>();
    for (Integer index = 0; index < 10; index++) {
      Contact con = new Contact();
      con.LastName = 'Name' + index;
      con.accountId = acc.Id;
      Contacts.add(con);
    }
    insert contacts;

    List<Opportunity> opportunities = new List<Opportunity>();
    for (Integer index = 0; index < 10; index++) {
      Opportunity opp = new Opportunity();
      opp.Name = 'Name' + index;
      opp.StageName = 'ClosedWon';
      opp.CloseDate = Date.parse('6/14/2023');
      opp.accountId = acc.Id;
      opportunities.add(opp);
    }
    insert opportunities;

    DynamicDao accountDynamicDao = new DynamicDao(Account.class);
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
    parentSoqlQueryClause.fieldFullNames = new List<String>{ 'Id', 'Name', 'AccountId' };
    parentSoqlQUeryClause.childRelationName = 'Account';
    firstChildSoqlQUeryClause.parentSoqlQueryClauses = new List<SoqlQueryClause>{ parentSoqlQueryClause };

    soqlQUeryClause.childSoqlQueryClauses = new List<SoqlQueryClause>{
      firstChildSoqlQueryClause,
      secondChildSoqlQueryClause
    };

    List<SObject> records = accountDynamicDao.getSObjectRecords(soqlQUeryClause);

    for (Account record : (List<Account>) records) {
      System.assertEquals(acc.Id, record.Id, 'Failed to get parent-records.');
    }
  }
}