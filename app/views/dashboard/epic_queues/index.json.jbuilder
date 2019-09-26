json.total @epic_queues.count
json.rows do
  json.(@epic_queues.limit(params[:limit]).offset(params[:offset])) do |eq|
    json.protocol     format_protocol(eq.protocol)
    json.pis          format_pis(eq.protocol)
    json.date         format_epic_queue_date(eq.protocol)
    json.status       format_status(eq.protocol)
    json.created_at   format_epic_queue_created_at(eq)
    json.name         eq.identity.full_name
    json.actions      epic_queue_actions(eq)
  end
end
