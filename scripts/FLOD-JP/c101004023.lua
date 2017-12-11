--エレメントセイバー・ラパウィラ
--Elementsaber Rapawira
--Scripted by Eerie Code
function c101004023.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101004023,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c101004023.negcon)
	e1:SetCost(c101004023.negcost)
	e1:SetTarget(c101004023.negtg)
	e1:SetOperation(c101004023.negop)
	c:RegisterEffect(e1)
	--att change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101004023,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1)
	e2:SetTarget(c101004023.atttg)
	e2:SetOperation(c101004023.attop)
	c:RegisterEffect(e2)
end
function c101004023.negcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c101004023.costfilter(c)
	return c:IsSetCode(0x400d) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c101004023.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local fc=Duel.IsPlayerAffectedByEffect(tp,101004060)
	local loc=LOCATION_HAND
	if fc then loc=LOCATION_HAND+LOCATION_DECK end
	if chk==0 then return Duel.IsExistingMatchingCard(c101004023.costfilter,tp,loc,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,c101004023.costfilter,tp,loc,0,1,1,nil):GetFirst()
	if tc:IsLocation(LOCATION_DECK) then
		Duel.Hint(HINT_CARD,0,101004060)
		local field=Duel.GetFirstMatchingCard(Card.IsHasEffect,tp,LOCATION_ONFIELD,0,nil,101004060)
		if field then field:RegisterFlagEffect(101004060,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,0) end
	end
	Duel.SendtoGrave(tc,REASON_COST)
end
function c101004023.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c101004023.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c101004023.atttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,563)
	local aat=Duel.AnnounceAttribute(tp,1,0xff-e:GetHandler():GetAttribute())
	e:SetLabel(aat)
end
function c101004023.attop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
