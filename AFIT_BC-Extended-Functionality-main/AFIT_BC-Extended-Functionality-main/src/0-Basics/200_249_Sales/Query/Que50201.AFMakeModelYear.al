query 50201 AFMakeModelYear
{
    Caption = 'AFMakeModelYear';
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
