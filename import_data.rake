#encoding: utf-8
namespace :db do
  desc "import data via task"
   task(:import_data => :environment) do
      txt = Spreadsheet.open("./1.xls") 
      sheet1 = txt.worksheet(0)
      parties = []
      party_id = []

      names = []
      name_id = []
      join_time = []
      join_time_in = []
      flag = false
# 获得单位名称，姓名，入党时间，转正时间

      sheet1.each do |row|
  	    if(flag)
			    parties << row[1]
			    names << row[2]
			    join_time << row[11]
			    join_time_in << row[12]
		    end
		    flag = true
      end

# 获得party_id
      txt = File.open("./parties.sql")
      @tmp = []
      txt.each do |f|
	      @tmp << f.split(',')

      end
      @result = @tmp.to_s.split("'")
      len = @result.length
      j = 0
      while(j != parties.length ) do
       i = 0
	      while(i != len ) do 
		
		      if (parties[j] == @result[i]) 
			
			      party_id[j] =  @result[i-2].to_i
						
		      end
		    i = i +1
	      end
	      j = j + 1
      end

    txt.close()

# 获得retiree_id
    txt2 = File.open("./retirees.sql")
      @temp = []
      txt2.each do |f|
	      @temp << f.split("\n")
       end
      @result =  @temp.to_s.split("'")
    len = @result.length
    j = 0
    while(j != names.length ) do 
    	i = 0 
	    while( i != len ) do 
		  if(names[j] == @result[i])
			  name_id[j] = @result[i-2].to_i
		  end
		  i = i + 1
	  end
	  j = j + 1
    end
  txt2.close()

# 处理时间格式  
    i = 0 
    while(i != join_time.length) do
	
	    join_time[i] = join_time[i].to_s[0..3]+"-"+join_time[i].to_s[4..5]+"-"+join_time[i].to_s[6..7]
	
	    i = i + 1
   end
		i = 0 
		while(i != join_time_in.length ) do 
			join_time_in[i] = join_time_in[i].to_s[0..3]+"-"+join_time_in[i].to_s[4..5]+"-"+join_time_in[i].to_s[6..7]
	i = i + 1
		end

		 
		for i in 0.. names.length
			party_member = {}
			if name_id[i].nil?
				next
			else	
				party_member['party_id'] = party_id[i]
				party_member['retiree_id'] = name_id[i]
				party_member['join_time'] = join_time[i]
				party_member['join_time_in']= join_time_in[i]
				PartyMember.create(party_member)
			end
		end
   end
end
