CREATE TABLE IF NOT EXISTS orders (
    id SERIAL PRIMARY KEY,
    user_id int,
    number_of_items int,
    total_amount int
);