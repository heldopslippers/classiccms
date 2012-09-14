module Classiccms
  module Helpers

    #for the test suite. Lets remove this laterrr!
    def ping
      'pong'
    end

    #insert the header for CMS to work
    def cms
      if defined? @user
        show :header, views: File.join(Classiccms::ROOT, 'views/cms')
      end
    end

    #insert the logout button
    def logout
      if @user != nil
        show :logout, views: File.join(Classiccms::ROOT, 'views/cms')
      end
    end
    def partial(file_name)
      show :"#{file_name}", {views: ['app/views']}
    end

    #generates url for a document
    def link(document, url)
      url = url.gsub(/[^a-zA-Z0-9\-\/]+/, '-').downcase
      slugs = Slug.where document_id: document.id
      if slugs.count > 0
        slug = slugs.first
      else
        slug = Slug.new
        slug.document_id = document.id
        slug.generate_id
        slug.save
      end
      "/#{slug.id}/#{url}"
    end

    #renders a specific page
    def layout(section_name, position)
      id = get_parent_id(position)
      records = Base.where(:_id => id)
      if records.count > 0 and records.first.connections.where(:section => section_name, :file.ne => nil).count > 0
        file_name = records.first.connections.where(:section => section_name, :file.ne => nil).first.file
        show file_name, {views: ["app/views/#{records.first._type}", "app/views/#{records.first._type.downcase}"]}, {record: records.first}
      else
        '404'
      end
    end

    def content_for(key, *args, &block)
      @sections ||= Hash.new{ |k,v| k[v] = [] }
      if block_given?
        @sections[key] << block
      else
        @sections[key].inject(''){ |content, block| content << block.call(*args) } if @sections.keys.include?(key)
      end
    end
    #renders all child pages of the given position (id)
    def section(section_name, parent_id = nil)
      html = ""
      parent_id = get_parent_id(parent_id)
      objects_to_render = {}
      Base.where(:'connections.parent_id' => parent_id, :'connections.section' => section_name, :'connections.file'.ne => nil).each do |record|
        connection = record.connections.where(:parent_id => parent_id, :section => section_name, :file.ne => nil).first

        if objects_to_render[connection.order_id] == nil
          number = connection.order_id
        else
          number = get_unique_number(objects_to_render, connection.order_id)
        end
        objects_to_render[number] = {:record => record, :connection => connection}
      end
      Hash[objects_to_render.sort].each do |k, object|
        html += show object[:connection].file, {views: ["app/views/#{object[:record]._type}", "app/views/#{object[:record]._type.downcase}"]}, {record: object[:record]}
      end
      return html
    end
    def get_unique_number(hash, number)
      if hash[number] == nil
        return number
      else
        return get_unique_number(hash, number+1)
      end
    end
    #returns the html for add button
    def add(*items)
      items.each do |item|
        if item.class == Array
          item[1] = get_parent_id(item[1])
        end
      end
      if @user != nil
        info = Base64.encode64(items.to_s.encrypt)
        show :add, {views: File.join(Classiccms::ROOT, 'views/cms')}, {encrypteddata: info}
      end
    end

    #returns the html for edit button
    def edit(id)
      records = Base.where(_id: id)
      if records.count > 0 and @user != nil
        info = Base64.encode64 records.first.id.to_s.encrypt

        show :edit, {views: File.join(Classiccms::ROOT, 'views/cms')}, {encrypteddata: info}
      end
    end

    #simple function that return id if user is allowed to sort the item
    def sort(object)
      if object.kind_of? Moped::BSON::ObjectId or object.kind_of? String
        object = Base.where(:_id => object).first
      end
      if @user != nil
        object.id.to_s
      end
    end

    private
    #Holy crap! It will return the id based upon the given position (in reverse)
    def get_parent_id(position)
      if position.kind_of? Integer
        routes = @routes.reverse
        if routes.length > position
          return routes[position]
        elsif routes.count > 0
          return get_parent_id(position-1)
        end
      else
        return position != nil ? position : @routes.first
      end
    end
  end
end
