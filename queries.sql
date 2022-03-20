#Selecting the name, code and description from all products.
#Selecionando o nome, código e descrição de todos os produtos.
SELECT 
    productCode, 
    productName, 
    textDescription
FROM
    products t1
INNER JOIN productlines t2 
    ON t1.productline = t2.productline;

#Select the name, price and how many products are available.
#Verificando a quantidade de produtos disponiveis, com nome e preço.    
SELECT 
    productCode, 
    priceEach,
    quantityOrdered
FROM
    orderdetails 
INNER JOIN products USING (productCode);

#Select all the customers who live in France and show your address.
#Visualizar todos os clientes que moram na França e seus dados postais.
SELECT 
    state, city, postalCode, country, phone, customerName
FROM
    customers
WHERE
    country = 'France'
ORDER BY 
    customerName,
    phone,
    country,
    state, 
    city,
    postalCode;

#Find the sales manager in the specific office.
#Encontrar o gerente de vendas.
SELECT 
    lastname, 
    firstname, 
    jobtitle,
    officeCode
FROM
    employees
WHERE
    jobtitle = 'Sales Manager (NA)' AND 
    officeCode = 1;

#Select all customers with the status resolved.
#Encontrar os clientes com status resolved.
SELECT
    c.customerNumber,
    customerName,
    orderNumber,
    status
FROM
    customers c
LEFT JOIN orders o 
    ON c.customerNumber = o.customerNumber
 WHERE
    status = 'Resolved';

#Select the customers with the amount bigger than 10 000.00 
#Selecionar os cliente com montante maior de 10 000,00
SELECT
    c.customerNumber,
    customerName,
    paymentDate,
    amount
FROM
    customers c
LEFT JOIN payments p 
    ON c.customerNumber = p.customerNumber
 WHERE
    amount > '10000.00';

#Here is an example of the difference between the left join and the right join.
#Exemplo da diferença entre left join e right join.
#Here all customers are shown even without an employee number.
SELECT 
    employeeNumber, 
    customerNumber
FROM
    customers
LEFT JOIN employees 
    ON salesRepEmployeeNumber = employeeNumber
ORDER BY 
	employeeNumber;
#Here all employee numbers are shown even without a customer number.
SELECT 
    employeeNumber, 
    customerNumber
FROM
    customers
RIGHT JOIN employees 
    ON salesRepEmployeeNumber = employeeNumber
ORDER BY 
	employeeNumber;

#Delete the customers that don't have sales orders.
#Deletar os clientes que não fizeram nenuma compra.
DELETE 
	customers 
FROM 
	customers c
LEFT JOIN
    orders o ON c.customerNumber = o.customerNumber 
WHERE
    orderNumber IS NULL;

#Verify if the delete worked.
#Verficar se o delete anterios funcionou.    
SELECT 
    c.customerNumber, 
    c.customerName, 
    orderNumber
FROM
    customers c
LEFT JOIN
    orders o ON c.customerNumber = o.customerNumber
WHERE
    orderNumber IS NULL;

#Mostrar os 10 primeiros clientes sem número de compra.
#Show the first 10 customers without a order number.
SELECT 
    c.customerNumber, 
    c.customerName, 
    o.orderNumber, 
    o.status
FROM
    customers c
LEFT JOIN orders o 
    ON c.customerNumber = o.customerNumber
WHERE
    orderNumber IS NULL
ORDER BY 
    customerNumber DESC    
LIMIT 10;

#Mostrar o mome do vendedor do comprador e o montante.
#Show the buyer's seller name and amount.
SELECT 
    firstName, 
    lastName, 
    customerName, 
    amount
FROM
    employees
LEFT JOIN customers ON 
    employeeNumber = salesRepEmployeeNumber
LEFT JOIN payments ON 
    payments.customerNumber = customers.customerNumber
ORDER BY 
    customerName; 
   
#Mostrar os funcionarios, a empresa que estão alocados, cidade em que moram e vendas que fizeram.
#Show the Employees, the company they are allocated, the city they live in and sales they made.
SELECT 
    firstName,
    lastName, 
    jobTitle,
    officeCode, 
    o.city
FROM
    employees e
RIGHT JOIN offices o USING (officeCode)
RIGHT JOIN customers ON 
    employeeNumber = salesRepEmployeeNumber
ORDER BY 
    firstName;

#Verificando o número do pedido, do cliente e o código do produto.
#Checking the order number, customer number and product code.
SELECT 
    o.orderNumber, 
    customerNumber, 
    productCode
FROM
    orders o
LEFT JOIN orderDetails d 
    ON o.orderNumber = d.orderNumber AND 
       o.orderNumber = 10123;
       
#Mostar tabela com concatenação de colunas usando o inner join para resgatar os dados.
#Show table with column concatenation using inner join to retrieve data.
SELECT 
    CONCAT(m.lastName, ', ', m.firstName) AS Manager,
    CONCAT(e.lastName, ', ', e.firstName) AS 'Direct report'
FROM
    employees e
INNER JOIN employees m ON 
    m.employeeNumber = e.reportsTo
ORDER BY 
    Manager;

#Mostar tabela com concatenação de colunas usando o left join para resgatar os dados.
#Show table with column concatenation using left join to retrieve data.
SELECT 
    IFNULL(CONCAT(m.lastname, ', ', m.firstname),
            'Top Manager') AS 'Manager',
    CONCAT(e.lastname, ', ', e.firstname) AS 'Direct report'
FROM
    employees e
LEFT JOIN employees m ON 
    m.employeeNumber = e.reportsto
ORDER BY 
    manager DESC;

#Show unit price multiplied by total purchased as amount and compare to status and year of purchase.  
#Mostre o preço unitário multiplicado pelo total comprado como valor e compare com o status e ano da compra.
SELECT 
    status,
    YEAR(orderDate) AS year,
    SUM(quantityOrdered * priceEach) AS amount
FROM
    orders
INNER JOIN orderdetails 
    USING (orderNumber)
GROUP BY 
    status;

#Show the unit price multiplied by the total purchaser as value and compare with the year of purchase, filtering by status.    
#Mostre o preço unitário multiplicado pelo total comprado como valor e compare com o ano da compra, filtrando pelo status.
SELECT 
    status,
    YEAR(orderDate) AS year,
    SUM(quantityOrdered * priceEach) AS amount
FROM
    orders
INNER JOIN orderdetails 
    USING (orderNumber)
WHERE
    status = 'Shipped'
GROUP BY 
    YEAR(orderDate);

#Mostra a quantidade ordenada como "itemsCount" e compara com "amount" (preço multiplicado pela quantidade).
#Shows the ordered quantity as "itemsCount" and compares with "amount" (price multiplied by quantity).    
SELECT 
    ordernumber,
    SUM(quantityOrdered) AS itemsCount,
    SUM(priceeach*quantityOrdered) AS amount
FROM
    orderdetails
GROUP BY ordernumber
HAVING 
    total > 1000 AND 
    itemsCount > 600;

#Mostra os números de pedido filtrando pelo status e "amount".
#Shows order numbers by filtering by status and "amount".
SELECT 
    a.ordernumber, 
    status, 
    SUM(priceeach*quantityOrdered) amount
FROM
    orderdetails a
INNER JOIN orders b 
    ON b.ordernumber = a.ordernumber
GROUP BY  
    ordernumber, 
    status
HAVING 
    status = 'Shipped' AND 
    amount > 1500;

#Selecionando o nome, código, descrição, vendedor e preço do produtos filtrados pelo valor e pelos algarismo do código.
#Selecting the name, code, description, seller and price of the products filtered by the value and the code digit.
SELECT 
    productCode,
    productName,
    productDescription, 
    productVendor, 
    priceEach
FROM
    products 
INNER JOIN orderdetails  USING (productCode)
HAVING 
    priceEach > 100 AND
    productCode = 4;

#Show data from offices concatenated city and country and filtering by code.
#Mostrar dados dos escritórios concatenado cidade e pais e filtrando por código.
SELECT 
	officeCode,
    postalCode,
    CONCAT(city, ', ', country) AS 'Nacionality',
    phone
FROM
    offices
WHERE
    officeCode > 3
ORDER BY 
    officeCode;
 
#Mostrar informações sobre o produto adquirido e ongraniza por data de envio.
#Show information about the purchased product and organize by shipping date.
SELECT
    productCode,
    priceEach,
    orderNumber,
    status,
    shippedDate
FROM
    orderdetails d
INNER JOIN orders  USING (orderNumber)
 WHERE
    status = 'Cancelled'
GROUP BY 
    shippedDate;
 
#É feita uma consulta dentro da consulta para buscar somente o maior valor.
#A query is made within the query to fetch only the highest value.
SELECT 
    customerNumber, 
    checkNumber, 
    amount
FROM
    payments
WHERE
    amount = (SELECT MAX(amount) FROM payments);

#The default query is even more selective filtering to find data from 2003 onwards.
#A consulta padrão é feita uma filtragem ainda mais seletiva para encontrar dados apartir de 2003.
SELECT 
    YEAR(orderDate) AS year,
    SUM(quantityOrdered * priceEach) AS amount
FROM
    orders
INNER JOIN orderdetails 
    USING (orderNumber)
WHERE
    status = 'Shipped'
GROUP BY 
    year
HAVING 
    year > 2003;

#Seleção com especificação de valor não nulo.
#Selection with non-null value specification.
SELECT 
    customerName, 
    country, 
    salesrepemployeenumber
FROM
    customers
WHERE
    salesrepemployeenumber IS NOT NULL
ORDER BY 
   customerName;
   
#Seleção de cliente por número e nome utilizando o operador "IN".
#Customer selection by number and name using the "IN" operator.
SELECT 
    customerNumber, 
    customerName
FROM
    customers
WHERE
    customerNumber IN (
        SELECT 
            customerNumber
        FROM
            orders);

#Seleção de cliente por número e nome utilizando o operador "EXISTS".
#Customer selection by number and name using the "EXISTS" operator.
SELECT 
    customerNumber, 
    customerName
FROM
    customers
WHERE
    EXISTS( 
        SELECT 
            1
        FROM
            orders
        WHERE
            orders.customernumber = customers.customernumber);

#Mostrar o mome do vendedor do comprador e o montante.
#Show the buyer's seller name and amount.
SELECT 
    firstName, 
    lastName, 
    customerName, 
    amount
FROM
    employees
LEFT JOIN customers ON 
    employeeNumber = salesRepEmployeeNumber
LEFT JOIN payments ON 
    payments.customerNumber = customers.customerNumber
ORDER BY 
    amount DESC
LIMIT
	20;

#Mostrar os funcionarios da empresa que estão alocados em Tokyo.
#Show the company's employees who are allocated in Tokyo.
SELECT 
    firstName,
    lastName, 
    jobTitle,
    officeCode, 
    o.city
FROM
    employees e
RIGHT JOIN offices o USING (officeCode)
RIGHT JOIN customers ON 
    employeeNumber = salesRepEmployeeNumber
WHERE 
	o.city = 'Tokyo'
ORDER BY 
    firstName;


    

      
    