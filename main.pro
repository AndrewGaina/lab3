implement main
    open core, file, stdio

domains
    accessory_type = cpu; motherboard; ram; storage; graphics_card; display; keyboard; mouse.
    brand_name = intel; amd; asus; gigabyte; samsung; dell; logitech; microsoft; nvidia; corsair.

class facts - computerdb
    accessory : (integer AccessoryID, string AccessoryName, accessory_type AccessoryType, brand_name Brand, string ManufactureDate).
    connection_interface : (integer AccessoryID, string Interface).
    connection_slot : (integer AccessoryID, string Slot).
    product : (integer AccessoryID, integer Price).
    compatibility : (integer AccessoryID1, integer AccessoryID2).

class predicates
    calculate_total_cost : (integer* Accessories, integer TotalCost) nondeterm anyflow.
    count_accessories : (accessory_type AccessoryType, integer Count) nondeterm anyflow.
    get_compatible_accessories : (integer AccessoryID, integer* CompatibleAccessories) nondeterm anyflow.
    get_brand_accessories : (brand_name Brand, integer* BrandAccessories) nondeterm anyflow.
    max : (integer* Accessories, integer MaxPrice) nondeterm anyflow.
    min : (integer* Accessories, integer MinPrice) nondeterm anyflow.
    get_avg_price : (integer* Accessories, real AvgPrice) nondeterm anyflow.
    find_accessory : (integer AccessoryID, string AccessoryName, accessory_type AccessoryType, brand_name Brand, string ManufactureDate)
        nondeterm anyflow.
    print_accessories : (integer* Accessories) nondeterm anyflow.
    get_prices : (integer* Accessories, integer* Prices) nondeterm anyflow.

clauses
    count_accessories(AccessoryType, Count) :-
        Accessories = [ AccessoryID || accessory(AccessoryID, _, AccessoryType, _, _) ],
        Count = list::length(Accessories).

    get_compatible_accessories(AccessoryID, CompatibleAccessories) :-
        CompatibleAccessories = [ AccessoryID2 || compatibility(AccessoryID, AccessoryID2) ].

    get_brand_accessories(Brand, BrandAccessories) :-
        BrandAccessories = [ AccessoryID || accessory(AccessoryID, _, _, Brand, _) ].

    %Вычисление количества и максимального / среднего / минимального значений характеристик при помощи обработки списков данных;
    calculate_total_cost([], 0) :-
        !.

    calculate_total_cost([AccessoryID | Rest], TotalCost) :-
        product(AccessoryID, Price),
        calculate_total_cost(Rest, RemainingCost),
        TotalCost = Price + RemainingCost.

    get_prices([], []).
    get_prices([AccessoryID | Rest], [Price | Prices]) :-
        product(AccessoryID, Price),
        get_prices(Rest, Prices).

    min([Item], Item).
    min([Item | List], Item) :-
        min(List, List_Answer),
        Item >= List_Answer,
        !.
    min([_Item | List], Answer) :-
        min(List, Answer).

    max([Item], Item).
    max([Item | List], Item) :-
        max(List, List_Answer),
        Item <= List_Answer,
        !.
    max([_Item | List], Answer) :-
        max(List, Answer).

    get_avg_price(Accessories, AvgPrice) :-
        calculate_total_cost(Accessories, TotalCost),
        Count = list::length(Accessories),
        AvgPrice = TotalCost / Count.

% Поиск данных предметной области как поиск элементов в списке
    find_accessory(AccessoryID, AccessoryName, AccessoryType, Brand, ManufactureDate) :-
        accessory(AccessoryID, AccessoryName, AccessoryType, Brand, ManufactureDate).

% Вывод данных предметной области как поэлементный вывод списка
    print_accessories([]).
    print_accessories([AccessoryID | Rest]) :-
        accessory(AccessoryID, AccessoryName, AccessoryType, Brand, ManufactureDate),
        write("Accessory ID: ", AccessoryID, "\n"),
        write("Name: ", AccessoryName, "\n"),
        write("Type: ", AccessoryType, "\n"),
        write("Brand: ", Brand, "\n"),
        write("Manufacture Date: ", ManufactureDate, "\n"),
        nl,
        print_accessories(Rest).

clauses
    run() :-
        console::init(),
        file::consult("../computerdb.txt", computerdb),
        % Example queries:
        count_accessories(cpu, CPUCount),
        write("Number of CPUs available: ", CPUCount, "\n"),
        count_accessories(ram, RAMCount),
        write("Number of RAM modules available: ", RAMCount, "\n"),
        nl,
        calculate_total_cost([1, 2, 3, 4], TotalCost),
        write("Total cost of PC from given accessories: ", TotalCost, "\n"),
        nl,
        write("Compatible accessories for Accessory ID 1: "),
        get_compatible_accessories(1, CompatibleAccessories),
        write(CompatibleAccessories, "\n"),
        nl,
        write("Accessories from brand Intel: "),
        get_brand_accessories(intel, BrandAccessories),
        write(BrandAccessories, "\n"),
        nl,
        get_prices([1, 2, 3, 4], Prices),
        write("Max price among all accessories: "),
        max(Prices, MaxPrice),
        write(MaxPrice, "\n"),
        write("Min price among all accessories: "),
        min(Prices, MinPrice),
        write(MinPrice, "\n"),
        write("Average price among all accessories: "),
        get_avg_price([1, 2, 3, 4], AvgPrice),
        write(AvgPrice, "\n"),
        nl,
        write("Accessories in the database:\n"),
        find_accessory(AccessoryID, AccessoryName, AccessoryType, Brand, ManufactureDate),
        write("Accessory ID: ", AccessoryID, "\n"),
        write("Name: ", AccessoryName, "\n"),
        write("Type: ", AccessoryType, "\n"),
        write("Brand: ", Brand, "\n"),
        write("Manufacture Date: ", ManufactureDate, "\n"),
        nl,
        fail.

    run() :-
        succeed.

end implement main

goal
    console::run(main::run).
