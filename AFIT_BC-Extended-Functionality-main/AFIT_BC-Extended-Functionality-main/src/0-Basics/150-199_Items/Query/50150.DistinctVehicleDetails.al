query 50150 "AF Distinct Vehicle Details"
{
    Caption = 'AF Distinct Vehicle Details';
    QueryType = Normal;

    elements
    {
        dataitem(AFItemVehicleEx; "AF Item Vehicle Ex")
        {
            column(Make; Make)
            {
            }
            column(Model; Model)
            {
            }
            column(Year; Year)
            {
            }
            column(Count)
            {
                Method = Count;
            }
        }
    }
}
