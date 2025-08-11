with customers as (

    select * from {{ ref("stg_jaffle_shop__customers")}}

),

orders as (

    select * from {{ ref("stg_jaffle_shop__orders")}}
),

customer_orders as (
    select 
        c.customer_id
        , min(orders.order_placed_at) as first_order_date
        , max(orders.order_placed_at) as most_recent_order_date
        , count(orders.order_id) as number_of_orders
    
    from customers c 
    
    left join orders
    
    on orders.order_id = c.customer_id 
    
    group by 1
)

select * from customer_orders
