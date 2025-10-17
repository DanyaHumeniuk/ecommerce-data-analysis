## LookML Model Definition (Conceptual)

# 1. FACT_Sales View (e.g., in fact_sales.view)
view: fact_sales {
  sql_table_name: FACT_Sales ;;

  dimension: sales_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.SalesID ;;
  }
  dimension_group: invoice_date {
    type: time
    timeframes: [date, week, month, quarter, year]
    sql: ${TABLE}.InvoiceDate ;;
  }
  dimension: invoice_number {
    type: string
    sql: ${TABLE}.InvoiceNo ;;
  }
  dimension: revenue {
    type: number
    sql: ${TABLE}.Sales_Revenue ;;
  }

  # KPI Measures
  measure: total_sales_revenue {
    type: sum
    sql: ${revenue} ;;
    value_format_name: usd
  }
  measure: total_orders {
    type: count_distinct
    sql: ${invoice_number} ;;
  }
  measure: average_order_value {
    type: number
    sql: ${total_sales_revenue} / ${total_orders} ;;
    value_format_name: usd
  }
}

# 2. DIM_Customer View (e.g., in dim_customer.view)
view: dim_customer {
  sql_table_name: DIM_Customer ;;

  dimension: customer_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.CustomerID ;;
  }
  dimension: country {
    type: string
    sql: ${TABLE}.Country ;;
  }
  dimension: customer_segment {
    type: string
    sql: ${TABLE}.Customer_Segment ;;
  }
  measure: customer_count {
    type: count_distinct
    sql: ${customer_id} ;;
  }
}