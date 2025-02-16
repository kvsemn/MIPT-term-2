CREATE TABLE Customers (
  	customer_id  PRIMARY key,
  	first_name	text,
	last_name text,	
	gender	text,
	DOB	text,
	job_title text,	
	job_industry_category text,
	wealth_segment text,
	deceased_indicator	text,
	owns_car	text,
	address	text,
	postcode int8,
	state	text,
	country	 text,
	property_valuation int8
);

CREATE TABLE ProductDetails (
  product_line VARCHAR(255) PRIMARY KEY,
  product_class VARCHAR(255),
  product_size VARCHAR(255)
);

CREATE TABLE ProductPricing (
  brand VARCHAR(255) NOT NULL,
  product_line VARCHAR(255) NOT NULL,
  list_price DECIMAL,
  standard_cost DECIMAL,
  FOREIGN KEY (product_line) REFERENCES ProductDetails(product_line),
  PRIMARY KEY (brand, product_line)
);

CREATE TABLE Products (
  product_id SERIAL PRIMARY KEY,
  brand VARCHAR(255) NOT NULL,
  product_line VARCHAR(255) NOT NULL,
  FOREIGN KEY (brand, product_line) REFERENCES ProductPricing(brand, product_line)
);

CREATE TABLE Transactions (
  transaction_id SERIAL PRIMARY KEY,
  customer_id INT NOT NULL,
  product_id INT NOT NULL,
  transaction_date DATE NOT NULL,
  online_order BOOLEAN,
  order_status VARCHAR(255),
  FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
  FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
