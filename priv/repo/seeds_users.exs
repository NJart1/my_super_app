alias MySuperApp.{Repo, Accounts, User}
Repo.delete_all(User)
for _ <- 1..20 do
Accounts.create_user(%{username: Faker.App.author(), email: Faker.Internet.email()})
end
