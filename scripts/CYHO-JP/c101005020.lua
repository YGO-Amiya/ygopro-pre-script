--コスモブレイン

--Script by nekrozar
function c101005020.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c101005020.sprcon)
	e1:SetOperation(c101005020.sprop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101005020,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101005020)
	e2:SetCost(c101005020.spcost)
	e2:SetTarget(c101005020.sptg)
	e2:SetOperation(c101005020.spop)
	c:RegisterEffect(e2)
end
function c101005020.sprfilter(c,tp)
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and not c:IsType(TYPE_EFFECT) and c:IsAbleToGraveAsCost() and Duel.GetMZoneCount(tp,c)>0
end
function c101005020.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c101005020.sprfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,tp)
end
function c101005020.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c101005020.sprfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,tp)
	local lv=g:GetFirst():GetLevel()
	Duel.SendtoGrave(g,REASON_COST)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(lv*200)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
end
function c101005020.costfilter(c,tp)
	return c:IsType(TYPE_EFFECT) and Duel.GetMZoneCount(tp,c,tp)>0
end
function c101005020.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c101005020.costfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,c101005020.costfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c101005020.spfilter(c,e,tp)
	return c:IsType(SUMMON_TYPE_NORMAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101005020.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101005020.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
end
function c101005020.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101005020.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end