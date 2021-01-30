module Paginable
  protected
  def current_page
    (params[:page] || 1).to_i
  end

  def per_page
    (params[:per_page] || 20).to_i
  end

  def get_links_serializer_options link_path, collection
    {
      links: {
        first: send(link_path,page: 1),
        last: send(link_path,page: collection.total_pages),
        prev: send(link_path,page: collection.prev_page),
        next: send(link_path,page: collection.next_page)
      }
    }

  end
end
