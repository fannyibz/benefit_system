# Benefit System

This application helps companies manage their employee benefits and reimbursement processes. It allows employees to:

1. **View Their Benefits**: Employees can see their various benefits (transport, healthcare, training, etc.) and their remaining balances.

2. **Request Reimbursements**: When employees spend their own money on eligible expenses, they can submit reimbursement requests directly through the platform.

3. **Track Balances**: The system automatically updates benefit balances when reimbursements are approved, ensuring employees never exceed their allocated amounts.

## Technical Stack

- Ruby on Rails
- PostgreSQL
- Docker
- Docker Compose

## Docker Setup

### Prerequisites
- Docker
- Docker Compose

### Local Development Setup

1. Clone the repository:

```
git clone [benefit_system](https://github.com/fannyibz/benefit_system)
cd benefit_system
```

2. Build the Docker images:

```
docker-compose build
```

3. Create and setup the database:

```
docker-compose run web rails db:create db:migrate rails db:seed
```

4. Start the application:
  
```
docker-compose up
```

The application will be available at http://localhost:3000

### Useful Commands

- Run the Rails console:

```
docker-compose run web rails console
```

- Run tests:

```
docker-compose run web rspec
```

- View logs:

```
docker-compose logs
```

- Stop the application:

```
docker-compose down
```

### Database Management

- Create database:

```
docker-compose run --rm web bundle exec rails db:create
```

- Migrate database:

```
docker-compose run --rm web bundle exec rails db:migrate
```

- Seed database:

```
docker-compose run --rm web bundle exec rails db:seed
```

- Reset database:
  
```
docker-compose run --rm web bundle exec rails db:drop db:create db:migrate
```

## Development

### Running Tests

```
docker-compose run --rm web bundle exec rspec
```

### Code Quality

```
docker-compose run --rm web bundle exec rubocop
```
