# frozen_string_literal: true

# создание таблиц и их наполнение
module Generator
  require 'faker'

  # основной метод модуля
  def create_queries
    File.open('script.sql', 'w') do |file|
      create_tables(file)
    end

    insert_into
  end

  # метод создания всех таблиц
  def create_tables(file)
    create_table_clients(file)
    create_table_children(file)
    create_table_banned_clients(file)
    create_table_speech_therapists(file)
    create_table_types(file)
    create_table_services(file)
    create_table_comments(file)
    create_table_contracts(file)
  end

  # метод заполнения всех таблиц
  def insert_into
    insert_into_clients
    insert_into_children
    insert_into_banned_clients
    insert_into_speech_therapists
    insert_into_types
    insert_into_services
    insert_into_comments
    insert_into_contracts
  end

  # метод создания таблицы клиентов
  def create_table_clients(file)
    file.puts("DROP TABLE IF EXISTS clients CASCADE;\n" \
              "CREATE TABLE clients (\n" \
              "\tid serial PRIMARY KEY,\n" \
              "\tsurname varchar(23) NOT NULL,\n" \
              "\tfirst_name varchar(23) NOT NULL,\n" \
              "\tpatronymic varchar(23) NOT NULL,\n" \
              "\tbirthday date NOT NULL,\n" \
              "\tphone varchar(11) NOT NULL,\n" \
              "\tpassport_series varchar(4) NOT NULL,\n" \
              "\tpassport_number varchar(6) NOT NULL,\n" \
              "\tregistration_date date NOT NULL\n" \
              ");\n\n")
  end

  # метод создания таблицы детей клиентов
  def create_table_children(file)
    file.puts("DROP TABLE IF EXISTS children;\n" \
              "CREATE TABLE children(\n" \
              "\tid serial PRIMARY KEY,\n" \
              "\tsurname varchar(23) NOT NULL,\n" \
              "\tfirst_name varchar(23) NOT NULL,\n" \
              "\tpatronymic varchar(23) NOT NULL,\n" \
              "\tbirthday date NOT NULL,\n" \
              "\tparent_id integer REFERENCES clients (id) NOT NULL" \
              ");\n\n")
  end

  # метод создания таблицы заблокированных пользователей
  def create_table_banned_clients(file)
    file.puts("DROP TABLE IF EXISTS banned_clients;\n" \
              "CREATE TABLE banned_clients(\n" \
              "\tid serial PRIMARY KEY,\n" \
              "\treason text NOT NULL,\n" \
              "\tban_date date NOT NULL,\n" \
              "\tclient_id integer REFERENCES clients (id) NOT NULL\n" \
              ");\n\n")
  end

  # метод создания таблицы логопедов
  def create_table_speech_therapists(file)
    file.puts("DROP TABLE IF EXISTS speech_therapists CASCADE;\n" \
              "CREATE TABLE speech_therapists(\n" \
              "\tid serial PRIMARY KEY,\n" \
              "\texperience integer NOT NULL,\n" \
              "\teducation text NOT NULL,\n" \
              "\tachievements text NOT NULL,\n" \
              "\tphoto_url text NOT NULL,\n" \
              "\tverificated boolean NOT NULL,\n" \
              "\tjob_start date NOT NULL,\n" \
              "\tjob_end date,\n" \
              "\tclient_id integer REFERENCES clients (id) NOT NULL\n" \
              ");\n\n")
  end

  # метод создания таблицы услуг логопедов
  def create_table_services(file)
    file.puts("DROP TABLE IF EXISTS services CASCADE;\n" \
              "CREATE TABLE services(\n" \
              "\tid serial PRIMARY KEY,\n" \
              "\tprice_per_hour integer NOT NULL,\n" \
              "\tdescription text NOT NULL,\n" \
              "\ttype_id integer REFERENCES types (id) NOT NULL\n" \
              ");\n\n")
  end

  # метод создания таблицы комментариев пользователей
  def create_table_comments(file)
    file.puts("DROP TABLE IF EXISTS comments;\n" \
              "CREATE TABLE comments(\n" \
              "\tid serial PRIMARY KEY,\n" \
              "\tbody text NOT NULL,\n" \
              "\trate_value integer NOT NULL,\n" \
              "\tcreation_date date NOT NULL,\n" \
              "\tclient_id integer REFERENCES clients (id) NOT NULL,\n" \
              "\tspeech_therapist_id integer REFERENCES speech_therapists (id) NOT NULL\n" \
              ");\n\n")
  end

  # метод создания таблицы типов услуг
  def create_table_types(file)
    file.puts("DROP TABLE IF EXISTS types CASCADE;\n" \
              "CREATE TABLE types(\n" \
              "\tid serial PRIMARY KEY,\n" \
              "\tname varchar(32) NOT NULL\n" \
              ");\n\n")
  end

  # метод создания таблицы договоров
  def create_table_contracts(file)
    file.puts("DROP TABLE IF EXISTS contracts;\n" \
              "CREATE TABLE contracts(\n" \
              "\tid serial PRIMARY KEY,\n" \
              "\thours integer NOT NULL,\n" \
              "\ttotal_cost integer NOT NULL,\n" \
              "\tissue_date date NOT NULL,\n" \
              "\tchild_id integer REFERENCES children (id) NOT NULL,\n" \
              "\tclient_id integer REFERENCES clients (id) NOT NULL,\n" \
              "\tservice_id integer REFERENCES services (id) NOT NULL,\n" \
              "\tspeech_therapist_id integer REFERENCES speech_therapists (id) NOT NULL\n" \
              ");\n")
  end

  # метод для заполнения таблицы клиентов
  def insert_into_clients
    names = parse_names

    File.open('clients_data.sql', 'w') do |file|
      file.puts('INSERT INTO clients (surname, first_name, patronymic, birthday, ' \
        'phone, passport_series, passport_number, registration_date) VALUES')

      39_999.times do |n|
        file.puts("\t('#{names[n][0]}', '#{names[n][1]}', '#{names[n][2]}', '#{random_birthday}', " \
          "'#{random_phone}', '#{random_passport_series}', '#{random_passport_number}', '#{random_date}'),")
      end

      file.puts("\t('#{names[-1][0]}', '#{names[-1][1]}', '#{names[-1][2]}', '#{random_birthday}', " \
         "'#{random_phone}', '#{random_passport_series}', '#{random_passport_number}', '#{random_date}');")
    end
  end

  def insert_into_children
    names = parse_names

    File.open('children_data.sql', 'w') do |file|
      file.puts('INSERT INTO children (surname, first_name, patronymic, birthday, parent_id) VALUES')

      19_999.times do |n|
        file.puts("\t('#{names[n][0]}', '#{names[n][1]}', '#{names[n][2]}', '#{random_child_birthday}', #{rand(1..40000)}),")
      end

      file.puts("\t('#{names[-1][0]}', '#{names[-1][1]}', '#{names[-1][2]}', '#{random_child_birthday}', #{rand(1..40000)});")
    end
  end

  # метод для заполнения таблицы заблокированных пользователей
  def insert_into_banned_clients
    File.open('banned_clients_data.sql', 'w') do |file|
      file.puts('INSERT INTO banned_clients (reason, ban_date, client_id) VALUES')
      99.times { file.puts("\t('#{random_reason}', '#{random_date}', #{rand(1..40_000)}),") }
      file.puts("\t('#{random_reason}', '#{random_date}', #{rand(1..40_000)});")
    end
  end

  # метод для заполнения таблицы логопедов
  def insert_into_speech_therapists
    File.open('speech_therapists_data.sql', 'w') do |file|
      file.puts('INSERT INTO speech_therapists (experience, education, achievements, photo_url,' \
        'verificated, job_start, job_end, client_id) VALUES')
      4_999.times do |n|
        file.puts("\t(#{rand(1..10)}, '#{random_education}', '#{random_achievements}', '#{Faker::Internet.url}', " \
          "#{[true, false].sample}, '#{random_date}', #{["NULL", "'#{random_date}'"].sample}, #{rand(1..40_000)}),")
      end

      file.puts("\t(#{rand(1..10)}, '#{random_education}', '#{random_achievements}', '#{Faker::Internet.url}', " \
        "#{[true, false].sample}, '#{random_date}', #{["NULL", "'#{random_date}'"].sample}, #{rand(1..40_000)});")
    end
  end

  # метод для заполнения таблицы услуг логопедов
  def insert_into_services
    File.open('services_data.sql', 'w') do |file|
      file.puts('INSERT INTO services (price_per_hour, description, type_id) VALUES')
      49_999.times { file.puts("\t(#{rand(1..10) * 1000}, '#{random_description}', #{rand(1..8)}),") }
      file.puts("\t(#{rand(1..18) * 1000}, '#{random_description}', #{rand(1..8)});")
    end
  end

  # метод для заполнения таблицы комментариев
  def insert_into_comments
    File.open('comments_data.sql', 'w') do |file|
      file.puts('INSERT INTO comments (body, rate_value, creation_date, client_id, speech_therapist_id) VALUES')
      99_999.times do
        comment = random_comment
        file.puts("\t('#{comment[1]}', #{comment[0]}, '#{random_date}', #{rand(1..40_000)}, #{rand(1..5000)}),")
      end
      comment = random_comment
      file.puts("\t('#{comment[1]}', #{comment[0]}, '#{random_date}', #{rand(1..40_000)}, #{rand(1..5000)});")
    end
  end

  # метод для заполнения таблицы типов услуг
  def insert_into_types
    File.open('types_data.sql', 'w') do |file|
      file.puts('INSERT INTO types (name) VALUES')
      (0..6).to_a.each_index { |i| file.puts("\t('#{random_type_name[i]}'),") }
      file.puts("\t('#{random_type_name[7]}');")
    end
  end

  # метод для заполения таблицы договоров
  def insert_into_contracts
    File.open('contracts_data.sql', 'w') do |file|
      file.puts('INSERT INTO contracts (hours, issue_date, total_cost, child_id, client_id, speech_therapist_id, service_id) VALUES')
      4_999_999.times do
        file.puts("\t(#{rand(1..20)}, '#{random_date}', #{rand(1..20) * 1000}, #{rand(1..20_000)}," \
                  "#{rand(1..40_000)}, #{rand(1..5_000)}, #{rand(1..50_000)}),")
      end
      file.puts("\t(#{rand(1..20)}, '#{random_date}', #{rand(1..20) * 1000}, #{rand(1..20_000)}," \
                "#{rand(1..40_000)}, #{rand(1..5_000)}, #{rand(1..50_000)});")
    end
  end

  # хуйня не получилоась
  # def file_creating(file_name, query_header, query_value, count)
  #   File.open(file_name, 'w') do |file|
  #     file.puts("INSERT INTO #{query_header} VALUES")
  #     count-1.times { |n| file.puts("\t(#{query_value}),") }
  #     file.puts("\t(#{query_value})")
  #   end
  # end

  # получение всех имен из файлов
  def parse_names
    File.open('names.txt', 'r:UTF-8').readlines.collect(&:split)
  end

  # случайный номер российского телефона (мск)
  def random_phone
    random_int_str = rand(1..999_999_999).to_s
    "89#{'0' * (9 - random_int_str.length)}#{random_int_str}"
  end

  # случайная серия российского паспорта
  def random_passport_series
    rand(1000..9999).to_s
  end

  # случайный номер российского паспорта
  def random_passport_number
    random_int_str = rand(1..999_999).to_s
    "#{'0' * (6 - random_int_str.length)}#{random_int_str}"
  end

  # случайная дата рождения
  def random_birthday
    Faker::Date.between(from: '1953-03-05', to: '2013-03-05')
  end

  # случайная дата для различных полей
  def random_date
    Faker::Date.between(from: '2020-01-01', to: '2023-02-06')
  end

  def random_reason
    [
      'Мошеничество',
      'Оскорбление других пользователй',
      'Оскорбление администрации',
      'Вмешательство в работу сервиса',
      'Создание фальшивого аккаунта',
      'Использование ботов',
      'Отправка спама',
      'Размещение неприемлемого контента'
    ].sample
  end

  def random_education
    [
      'Московский педагогический государственный университет, факультет логопедии',
      'Российский государственный педагогический университет Герцена, кафедра логопедии',
      'Московский государственный университет психологии и образования, факультет логопедии',
      'Российский государственный социальный университет, факультет логопедии'
    ].sample
  end

  def random_achievements
    [
      'Участие в международных конференциях по педагогике',
      'Прохождение курсов по логопедии',
      'Помог больше, чем 1000 детей',
      'Участие в научных работах по логопедии',
      'Участие в олимпиадах по педагогике'
  ].sample
  end

  def random_description
    [
      'Нужен логопед ребенку с нарушением произношения буквы "Р"',
      'Нужна помощь ребенку с произношением буквы "Л"',
      'Ребенок заикается, нужна помощь логопеда',
      'Ребенок не понимает свою речь',
      'Ребенок неправильно произносит многие буквы',
      'Как я сам могу помочь ребенку улучшить его речь',
      'Ребенок не понимает, что говорит'
  ].sample
  end

  def random_comment
    [
      [1, 
        [
          'Логопед отвратительно выполнил услугу',
          'Логопед плохо разбирается в своем деле',
          'Отвратительный логопед'
        ].sample
      ],
      [2,
        [
          'Посредственный логопед',
          'Не доволен выполненными услугами'
        ].sample
      ],
      [3,
        [
          'Нормальный логопед, но денег берет много',
          'Логопед неплохой, но мог бы разговаривать более вежливо'
        ].sample
      ],
      [4,
        [
          'Хороший логопед, и цены приемлемы',
          'Услугу выполним полностью, все согласно договора',
        ].sample
      ],
      [5,
        [
          'Отличный логопед, цены хорошие, все в срок, эффект чувствуется',
          'Все прекрасно, спасибо логопеду, все довольны',
          'Логопед молодчина, помог исправить проблему у ребенка',
          'Всем рекомендую этого логопеда'
        ].sample
      ]
    ].sample
  end

  def random_type_name
    [
      'Развитие речи',
      'Развитие звукопроизношения',
      'Развитие понимания речи',
      'Лечение заикания',
      'Работа с аутизмом',
      'Помощь с нарушениями речи',
      'Помощь родителям',
      'Профилактические мероприятия'
    ]
  end

  def random_child_birthday
    Faker::Date.between(from: '2017-03-05', to: '2021-03-05')
  end
end
