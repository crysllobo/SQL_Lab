use supply_db ;


/*
Question : Golf related products

List all products in categories related to golf. Display the Product_Id, Product_Name in the output. Sort the output in the order of product id.
Hint: You can identify a Golf category by the name of the category that contains golf.

*/

SELECT 
    Product_Name, Product_Id
FROM
    product_info prod_info
        JOIN
    category cat ON prod_info.category_id = cat.id
WHERE
    cat.name LIKE '%Golf%'
ORDER BY Product_Id;

-- **********************************************************************************************************************************

/*
Question : Most sold golf products

Find the top 10 most sold products (based on sales) in categories related to golf. Display the Product_Name and Sales column in the output. Sort the output in the descending order of sales.
Hint: You can identify a Golf category by the name of the category that contains golf.

HINT:
Use orders, ordered_items, product_info, and category tables from the Supply chain dataset.


*/

WITH category AS 
(SELECT 
    Id
FROM
    category
WHERE
    Name LIKE '%Golf%'),
golf AS
(SELECT 
    Product_id, Product_Name
FROM
    product_info prod_info
        INNER JOIN
    category cat ON prod_info.category_id = cat.id
ORDER BY product_id)
SELECT 
    Product_Name, SUM(Sales) AS Sales
FROM
    golf g
        INNER JOIN
    ordered_items ord_itm ON g.product_id = ord_itm.item_id
GROUP BY Product_Name
ORDER BY Sales DESC
LIMIT 10;

-- **********************************************************************************************************************************

/*
Question: Segment wise orders

Find the number of orders by each customer segment for orders. Sort the result from the highest to the lowest 
number of orders.The output table should have the following information:
-Customer_segment
-Orders


*/

SELECT 
    cust_info.Segment AS customer_segment,
    COUNT(ord.Order_Id) AS Orders
FROM
    orders ord
        LEFT JOIN
    customer_info cust_info ON ord.customer_id = cust_info.Id
GROUP BY customer_segment
ORDER BY Orders DESC;

-- **********************************************************************************************************************************
/*
Question : Percentage of order split

Description: Find the percentage of split of orders by each customer segment for orders that took six days 
to ship (based on Real_Shipping_Days). Sort the result from the highest to the lowest percentage of split orders,
rounding off to one decimal place. The output table should have the following information:
-Customer_segment
-Percentage_order_split

HINT:
Use the orders and customer_info tables from the Supply chain dataset.


*/

WITH seg_orders AS
(SELECT 
    cust_info.Segment AS customer_segment,
    ROUND(COUNT(ord.Order_Id), 1) AS Orders
FROM
    orders ord
        LEFT JOIN
    customer_info cust_info ON ord.customer_id = cust_info.id
WHERE
    real_shipping_days = 6
GROUP BY customer_segment)
SELECT 
    a.customer_segment,
    ROUND((a.Orders / SUM(b.Orders)) * 100, 1) AS percentage_order_split
FROM
    seg_orders a
        JOIN
    seg_orders b
GROUP BY a.customer_segment
ORDER BY percentage_order_split DESC;

-- **********************************************************************************************************************************
