module Classiccms
  module Routing

    #in charge of get the first item of a given model (for menu items etc.)
    def get_first_item
      records = Base.where(:'connections.parent' => nil, :'connections.section' => CONFIG[:section], :_type => CONFIG[:model])
      if records.count > 0
        records.order_by(:'connections.order_id').first
      end
    end

    #This method will get you the most awesome route through a tree! (OMG!)
    def get_route(current, routes = [])
      if current.kind_of? Base
        routes << current.id
        branches = Array.new
        current.connections.each_with_index do |connection, i|
          if connection.parent_id != nil and Base.where(:_id => connection.parent_id).count > 0
            branches[i] = get_route(Base.find(connection.parent_id))
          end
        end
        new = Array.new
        branches.each do |branch|
          if new.count == 0 or new.count > branch.count
            new = branch
          end
        end
        routes += new
      end
      routes
    end
  end
end
