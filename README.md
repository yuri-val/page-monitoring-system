# Завдання DEV Challenge 11

### Написати систему моніторингу за змінами у текстах новин / оголошень на сайті, збереження історії змін.

**Вхідні дані:** Оберіть будь-який сайт, який містить список публікацій (з пейджинатором).
Наприклад, це може бути ось цей [сайт](https://goo.gl/szTeTD) (або будь-який інший).

**Моніторинг:** Система має вміти сканувати публікації, на які ведуть посилання, переходити по
сторінках у списку та зберігати контент (лише html, без файлів).
Потрібно передбачити регулярне сканування найсвіжіших сторінок, і трішки рідше - більш
старих сторінок. У разі виявлення змін у тесті публікації (документа) система має зберігати нову
версію.
Врахуйте, що сторінка може також і зникати, тому такі випадки також потрібно виявляти.
Запускати job сканування можна будь-яким зручним для вас способом:
- Автоматично за таймером (або scheduler-ом)
- Шляхом виклику методу API (регулярність в такому випадку буде забезпечуватись
ззовні шляхом регулярного виклику методу)
- Інші способи, які ви оберете

**Очікуваний результат:** API, що надає доступ до списку всіх публікацій, до списку змінених або
видалених публікацій та до різних версій однієї публікації.
Ми очікуємо побачити у зручному вигляді diff (різницю) між різними версіями додатку. Видача
результату, наприклад, може бути шляхом виклику методу API з параметрами - версіями
документу, у відповідь може бути колекція доданих і видалених частин, наприклад. Алгоритм і
вигляд результату повністю обираєте ви - головне, опишіть ваш хід думок. Можна
використовувати сторонні бібліотеки.


# README

## How to run

### Run with docker:


    docker-compose build
    docker-compose run web rake db:drop db:create db:migrate
    docker-compose run web rake sites:example
    docker-compose run web whenever --update-crontab
    docker-compose up


If you need, you may use not PG DB. Just rename file `database.yml.mysql_example`
or `database.yml.sqlite_example` to `database.yml`.
Also you have to change db parameters for MySQL and PG in `database.yml`.

### Direct run (ruby >= 2.3.x):


    bundle install
    rake db:drop db:create db:migrate
    rake sites:example
    whenever --update-crontab
    rails s


Go to root application url (`127.0.0.1:3000`) for more info about routes.

## Site management

If you want to add new site, just run `rake sites:add` and follow wizard.

Also you can manage existing sites (show sites list, edit or delete). Use follow
command: `rake sites:manage`

## Routing

### Routes:
  - `/v1/sites/{:id}` -- list of all sites in db or site by {:id}
  - `/v1/articles/{:id}` -- list of all articles in db or article by {:id}
  - `/v1/versions/{:id}` -- list of all versions in db or version by {:id}
  - `/v1/statuses/{:id}` -- list of all statuses in db or status by {:id}
  - `/v1/articles/changed` -- list of all changed articles (versions count > 1)
  - `/v1/versions/:id/:type` -- get full text of article version `type={html_text|plain_text}`
  - `/v1/versions/:id/diff/:another_id` -- get diff of two versions: `id` - current version id, `another_id` - original version id

        also you can add parameters for this `url`
        [url]?par1=val1[&par2=val2]
        Parameter: {Value1|Value2}
         text: {plain_text|html_text} default:plain_text
         format: {ascii|color|html|array} default:array
         diff_by: {line|word|char} default:word
         type: {html|json} default:json"

     - `text` - which type of text will be diffed (html or plain)
     - `format` - in which way will be presented result
     - `diff_by` - in which way will be diffed text
     - `type` - type of responce

### Nested routes:
  - `/v1/sites/:site_id/articles/{:id}` -- list of site articles
  - `/v1/articles/:article_id/versions/{:id}` -- list of article versions
  - `/v1/statuses/:status_id/articles/{:id}` -- list of articles by status

## Monitoring

### Manual

You can manualy start monitoring of `active` sites.

Just run:
  - `[docker-compose run web ]rake monitoring:all` - to scan all pages (set in site `pages_to_scan`)
  - `[docker-compose run web ]rake monitoring:fresh` - to scan only first(news) page (set in site `site_url`)

`[docker-compose run web ]` need if you start your app in `docker`
### Automatic

Also this tasks can work automaticaly by gem `whenever`.

Schedule you can see/edit at `config/schedule.rb`

## Diff

You can simply watch the difference between the versions of the files by going to `/v1/versions/:id/diff/:another_id`
Where as **required** parameters are passed `id` of different versions. Also, in addition to `id`
You can specify the following **optional** parameters `text`,` format`, `diff_by` and `type`.
Working with parameters and their meaning is described in the [Routes](#routes) section .
