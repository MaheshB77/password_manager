const createPasswordTable = '''
        CREATE TABLE passwords (
          id TEXT PRIMARY KEY,
          title TEXT NOT NULL,
          username TEXT NOT NULL,
          password TEXT NOT NULL,
          categoryId TEXT NOT NULL,
          email TEXT,
          note TEXT,
          iconId TEXT,
          createdAt TEXT,
          updatedAt TEXT
        );
      ''';

const createCategoriesTable = '''
        CREATE TABLE categories (
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL
        );
    ''';

const createUserTable = '''
        CREATE TABLE user (
          id TEXT PRIMARY KEY,
          master_password TEXT NOT NULL,
          createdAt TEXT,
          updatedAt TEXT
        );
    ''';

const createCardTable = '''
        CREATE TABLE card (
          id TEXT PRIMARY KEY,
          card_category_id TEXT,
          card_number TEXT,
          card_holder_name TEXT,
          pin TEXT,
          cvv TEXT,
          issue_date TEXT,
          expiry_date TEXT,
          created_at TEXT,
          updated_at TEXT,

          FOREIGN KEY(card_category_id) REFERENCES card_category(id)
        );
''';

const createCardCategoryTable = '''
        CREATE TABLE card_category (
          id TEXT PRIMARY KEY,
          name TEXT
        );
''';

const updateCardCategoryTable1 = '''
        ALTER TABLE card_category ADD COLUMN icon;
''';