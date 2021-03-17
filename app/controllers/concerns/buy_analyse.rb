module BuyAnalyse
  extend ActiveSupport::Concern
  ####################消费分析###################
  def consume_by
    data1 = PipItemconsumeDay.select('statdate,goldconsume, goldbycharge,goldbygame').by_gameid(@gid).by_date(@sdate,@edate).group_by(&:statdate)
    data1 = data1.where(regionid: params[:ps].split(',')) if params[:ps].present?

    data1.each do |key, vals|
      data1[key] = vals.reduce(Hash.new(0)) do |res, obj|
        res[:gold_consume] += obj.goldconsume.to_i
        res[:gold_by_charge] += obj.goldbycharge.to_i
        res[:gold_by_game] += obj.goldbygame.to_i
        res[:gold_consume_by_charge] += obj.goldconsume.to_i if obj.goldbycharge.to_i > 0
        res
      end
    end

    result = []
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

    Rails.logger.debug result
    render json: result
  end



end
