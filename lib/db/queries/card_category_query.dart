const createCardCategoryTable = '''
        CREATE TABLE card_category (
          id TEXT PRIMARY KEY,
          name TEXT
        );
''';

const updateCardCategoryTable1 = '''
        ALTER TABLE card_category ADD COLUMN icon;
''';

const updateCardCategoryTable2 = '''
        ALTER TABLE card_category ADD COLUMN dark_icon TEXT;
''';
