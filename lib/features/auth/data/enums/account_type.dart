enum AccountType { influencer, company }

extension AccountTypeExtension on AccountType {
  static Map<String, AccountType> map = {
    "influencer": AccountType.influencer,
    "company": AccountType.company,
  };

  static AccountType fromString(String value) {
    return map[value]!;
  }
}
