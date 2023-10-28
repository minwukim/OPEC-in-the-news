Metadata Files Overview


1)  Metadata Descriptions

    Link to Data Dictionary: 
    •   https://tdmstudio.proquest.com/assets/data/TDM_Export_Metadata_Dictionary.csv
    
    Column Explanation
    •   Tag:         Tag name as shown in the XML of document
    •   Content:     The content of the tag
    •   Definition:  The definition of the content of the tag
    •   Example:     An example of what the content may look like
    •   Data Type:   The data type of the content (either string or numeric)


2)  Reading the Data and Data Software Size Limits

    Missing/Omitted Values
    •   If a cell does not have a value, it is stored as a blank value or empty list.
    •   If none of the documents in your dataset have a certain Metadata tag, that Metadata column is entirely omitted from the csv
    
    Excel Limitations
    •   Excel has a current row limit of 1,048,576 and size limit of ~2 GBs
    
    Handling Large Files
    •   If the dataset file size is too large...
        •   Consider splitting the dataset into smaller parts when you create the dataset
        •   If you work with Python or R, the csv can be opened using other tabular analysis libraries (e.g. pandas)
   
 
3)  Legal Notice 

    This export functionality is provided in connection with your institution’s TDM Studio subscription. The metadata export is restricted to use by Authorized Users for teaching, learning, research and analysis. The metadata exported is subject to the Terms and Conditions of TDM Studio: https://about.proquest.com/en/about/Supplemental-Terms-of-Use-TDM-Studio

    Researchers may:
    •   Use such metadata in a locally loaded corpus for text and data mining by Authorized Users, only so long as their institution has a subscription to TDM Studio.
    •   Retain and use the metadata and any Derived Data for teaching, learning, and research validation.

    Researchers shall not:
    •   Redistribute, resell or make any commercial use of the metadata or Derived Data.
    •   Use the metadata or Derived Data to create products or perform services which compete or interfere with those of ProQuest or its licensors.
    •   Use the metadata or Derived Data with any third-party services that retain, incorporate and/or use such data to train or improve the service's AI models or other offerings.



Last Updated 7/12/2023














