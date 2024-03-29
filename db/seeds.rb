# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

@church = Church.create(
  name: "Brasilândia",
  location: "Rua da Brasilandia, 123, Brasilandia, São Gonçalo, Rio de Janeiro",
  is_head: true
)
@julio = User.create(
  name: "Julio",
  title: User::POSSIBLE_TITLES[0],
  email: "admin@email.com.br",
  phone: "(21)9#{rand(7000..9999)}-#{rand(1000..9999)}",
  password: "12345678",
  password_confirmation: "12345678",
  birthdate: "16/02/1970",
  marital_status: 1,
  gender: 0,
  location: "Rua do Admin, 123, São Gonçalo, Rio de Janeiro",
  church: @church,
  member_since: "15/11/2018",
  is_baptized: true,
  access_garantied_at: Time.zone.now,
  access_garantied_by: "Sistema",
  president_pastor: true,
  is_leader: true
)
Filter::Create.call(
  performer: @julio,
  filter_params: { source: 'users' }
)


def create_user(user_params, church, access_params)
  puts "church: #{church.name}"
  User::Create.call(
    performer: @julio,
    user_params: user_params,
    church: church,
    access_params: access_params,
    skip_mailer_notification: true
  )
end


Church.create(
  name: "Porto da Pedra",
  location: "Rua do Porto da Pedra, 123, Porto da Pedra, São Gonçalo, Rio de Janeiro"
)

ministeries = ["Louvor", "Obreiros", "Infantil", "Oração"]

Church.find_each do |church|
  puts "começou a trabalhar o #{church.name}"
  ministeries.each do |ministery|
    puts "criando ministerio #{ministery}"
    Ministery.create(
      name: ministery,
      description: Faker::Lorem.paragraph,
      church: church
    )
  end

  min_members = rand(40..60)

  members = church.users.length
  puts "members atuais = #{church.users.length}, min members = #{min_members}"
  while members < min_members do
    user_params = {
      name: Faker::Name.name,
      email: Faker::Internet.email,
      title: User::POSSIBLE_TITLES[rand(1..3)],
      phone: "(21)9#{rand(7000..9999)}-#{rand(1000..9999)}",
      birthdate: Faker::Date.between(from: '1960-01-01', to: '2018-12-12'),
      marital_status: rand(0..4),
      gender: rand(0..1),
      location: Faker::Address.full_address,
      notes: Faker::Lorem.paragraph,
      member_since: Faker::Date.between(from: '2018-01-01', to: '2021-11-21'),
      is_baptized: rand(0..1)
    }
    action = create_user(user_params, church, {})
    if action.success?
      puts "user #{action.user.name} criado"
      members += 1
      update_params = {
        ministeries_ids: church.ministeries.pluck(:id).sample(2)
      }

      User::Update.call(
        user: action.user,
        performer: @julio,
        user_params: update_params
      )
    end
  end

  (0...6).to_a.each do |t|
    beginning_of_month = Date.today.beginning_of_month - t.month
    Cult.create!(
      date_of: beginning_of_month,
      responsible: @julio,
      church: church
    )
  end

  Cult.find_each do |cult|
    (0..50).to_a.each do
      Proselyte.create!(
        cult: cult,
        name: Faker::Name.name,
        phone: "(21)9#{rand(7000..9999)}-#{rand(1000..9999)}"
      )
    end

  end
end

update_params = {
  ministeries_ids: @church.ministeries.pluck(:id).sample(2)
}

User::Update.call(
  user: @julio,
  performer: @julio,
  user_params: update_params
)
