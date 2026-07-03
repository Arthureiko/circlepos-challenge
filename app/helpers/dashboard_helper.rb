module DashboardHelper
  def format_month_label(month)
    Date.strptime(month, "%Y-%m").strftime("%b %Y")
  rescue ArgumentError, TypeError
    month
  end

  def delta_color_class(value)
    return "text-gray-500" if value.nil? || value.zero?
    value.positive? ? "text-emerald-600" : "text-rose-600"
  end

  def delta_arrow(value)
    return "→" if value.nil? || value.zero?
    value.positive? ? "▲" : "▼"
  end

  def currency_symbol(currency)
    { "NZD" => "NZ$", "AUD" => "A$" }.fetch(currency, "#{currency} ")
  end

  def format_money(value, currency)
    number_to_currency(value, unit: currency_symbol(currency), precision: 2)
  end

  def format_pct(value)
    return "0%" if value.nil?
    "#{value.positive? ? "+" : ""}#{value}%"
  end
end
