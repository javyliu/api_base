module BuyAnalyse
  extend ActiveSupport::Concern
  ####################消费分析###################
  #by item:道具, consume:消费汇总（默认）,
  def consume_by
    result = []
    divisor = PipItemconsumeDay::ConsumeDivisor[@gid.to_i].to_f
    by = case params[:by]
         when 'item','feeitem','nofeeitem'
           data1 = PipItemconsumeDay.select('regionid, iteminfo').by_gameid(@gid).by_date(@sdate,@edate)
           data1 = data1.where('goldbycharge>0') if params[:by] == 'feeitem'
           data1 = data1.where('goldbycharge=0') if params[:by] == 'nofeeitem'
           :like_item
         when 'ybleft'
           data1 = PipBalanceInfo.select('sum(abalance) abalance, sum(bbalance) bbalance').by_gameid(@gid).where(type: params[:acttype] || 0, statdate: @sdate).first
           :ybleft
         else
           data1 = PipItemconsumeDay.select('statdate,goldconsume, goldbycharge,goldbygame').by_gameid(@gid).by_date(@sdate,@edate)
           :like_consume
         end
    data1 = data1.where(regionid: params[:ps].split(',')) if params[:ps].present?

    case by
    when :ybleft
      Rails.logger.debug data1
      tmp = {abalance: (data1.abalance.to_f/divisor).round(2), bbalance: (data1.bbalance.to_f/divisor).round(2)}
      tmp[:sumbalance] = (tmp[:abalance] + tmp[:bbalance]).round(2)
      result.push(tmp)
    when :like_item
      data1.each {|obj| obj.regionid = 0} if params[:ps].blank?
      data1 = data1.group_by(&:regionid)
      data1.each do |key,vals|
        data1[key] = vals.map(&:iteminfo).join(";").scan(/([^;%]+)%(\d+)%(\d*)/).group_by{|it| it.first}
      end
      data1.each do |_key, vals|
        vals.each do |key, ary|
          tmp = {}
          tmp[:region] = _key == 0 ? "全区" : "#{_key}区"
          tmp[:item] = key
          tmp1 = ary.reduce(Hash.new(0)) do |sum,_ary|
            sum[:count] += _ary[1].to_i
            sum[:yb] += _ary[2].to_i
            sum
          end
          tmp1[:yb] = (tmp1[:yb] / divisor).round(2)
          tmp1[:money] = (tmp1[:yb] / 10).round(2)
          tmp1[:avg] = (tmp1[:yb] / tmp1[:count]).round(2)
          result.push(tmp.merge(tmp1))
        end
      end
      Rails.logger.debug result.length

    when :like_consume
      data1 = data1.group_by(&:statdate)
      data1.each do |key, vals|
        data1[key] = vals.reduce(Hash.new(0)) do |res, obj|
          res[:gold_consume] += obj.goldconsume.to_i
          res[:gold_by_charge] += obj.goldbycharge.to_i
          res[:gold_by_game] += obj.goldbygame.to_i
          res[:gold_consume_by_charge] += obj.goldconsume.to_i if obj.goldbycharge.to_i > 0
          res
        end
      end

      (@sdate..@edate).each do |dt|
        date = dt.to_s(:db)
        it = data1[date] || Hash.new(0)
        tmp = {}
        divisor = PipItemconsumeDay::ConsumeDivisor[@gid.to_i].to_f
        tmp[:date] = date
        #消耗元宝
        tmp[:consume] = (it[:gold_consume]/divisor).round(2)
        #元宝获得-充值
        tmp[:by_charge] = (it[:gold_by_charge]/divisor).round(2)
        #元宝获得-游戏赠送
        tmp[:by_game] = (it[:gold_by_game]/divisor).round(2)
        #获得元宝
        tmp[:got] = (tmp[:by_charge] + tmp[:by_game]).round(2)
        #元宝产销比
        tmp[:rate] = (tmp[:got] / tmp[:consume]).round(2)
        #消耗元宝-付费用户
        tmp[:con_by_charge] = (it[:gold_consume_by_charge]/divisor).round(2)
        result.push(tmp)
      end
    end

    Rails.logger.debug result
    render json: result
  end



end
