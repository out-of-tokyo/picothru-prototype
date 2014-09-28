class Array
    def merge_by_index(other,index1='id',index2=nil)
        index2 = index1 if index2.nil?
        merge_hash = {}
        self.map {|data| merge_hash[data[index1]] = data}
        other.each do |data|
            key = data[index2]
            data[index1] = key if index1 != index2
            data.delete(index2) if index1 != index2
            merge_hash[key] = (merge_hash[key] == nil) ? data : merge_hash[key].merge(data) 
        end
        return merge_hash.values 
    end 
end