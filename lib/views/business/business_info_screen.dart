// // lib/views/business/business_info_screen.dart - ENHANCED VERSION MATCHING DASHBOARD
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../providers/auth_provider.dart';
// import '../../providers/business_provider.dart';
// import '../../widgets/common/loading_widget.dart';
// import '../../widgets/common/error_widget.dart';
// import 'widgets/business_header_card.dart';
// import 'widgets/business_details_card.dart';
// import 'widgets/business_hours_card.dart';
// import 'widgets/business_services_card.dart';

// class BusinessInfoScreen extends StatefulWidget {
//   const BusinessInfoScreen({Key? key}) : super(key: key);

//   @override
//   State<BusinessInfoScreen> createState() => _BusinessInfoScreenState();
// }

// class _BusinessInfoScreenState extends State<BusinessInfoScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _loadBusinessData();
//   }

//   void _loadBusinessData() {
//     final businessProvider = Provider.of<BusinessProvider>(context, listen: false);
//     businessProvider.loadBusinessData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer2<AuthProvider, BusinessProvider>(
//       builder: (context, authProvider, businessProvider, child) {
//         return Scaffold(
//           backgroundColor: const Color(0xFFF8F9FA),
//           body: SafeArea(
//             child: Column(
//               children: [
//                 // ENHANCED HEADER - Same as Dashboard
//                 Container(
//                   height: 65,
//                   padding: const EdgeInsets.symmetric(horizontal: 18),
//                   child: Row(
//                     children: [
//                       IconButton(
//                         icon: const Icon(
//                           Icons.arrow_back_ios_rounded,
//                           color: Color(0xFF4FC3F7),
//                           size: 24,
//                         ),
//                         onPressed: () => Navigator.of(context).pop(),
//                       ),
//                       const Spacer(),
//                       Text(
//                         'Business Information',
//                         style: TextStyle(
//                           fontFamily: 'Poppins',
//                           fontWeight: FontWeight.bold,
//                           fontSize: 22,
//                           color: const Color(0xFF2C3E50),
//                         ),
//                       ),
//                       const Spacer(),
//                       IconButton(
//                         icon: Icon(
//                           businessProvider.isEditing ? Icons.save_rounded : Icons.edit_rounded,
//                           color: const Color(0xFF4FC3F7),
//                           size: 24,
//                         ),
//                         onPressed: () {
//                           if (businessProvider.isEditing) {
//                             _saveChanges();
//                           } else {
//                             businessProvider.toggleEditMode();
//                           }
//                         },
//                       ),
//                     ],
//                   ),
//                 ),

//                 // MAIN CONTENT
//                 Expanded(
//                   child: businessProvider.isLoading
//                       ? const LoadingWidget(message: 'Loading business information...')
//                       : businessProvider.errorMessage != null
//                           ? CustomErrorWidget(
//                               message: businessProvider.errorMessage!,
//                               onRetry: _loadBusinessData,
//                             )
//                           : RefreshIndicator(
//                               onRefresh: () async => _loadBusinessData(),
//                               color: const Color(0xFF4FC3F7),
//                               child: SingleChildScrollView(
//                                 physics: const AlwaysScrollableScrollPhysics(),
//                                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     if (businessProvider.hasData) ...[
//                                       // Business Header Card
//                                       _buildEnhancedBusinessHeader(businessProvider.business!),
                                      
//                                       const SizedBox(height: 20),
                                      
//                                       // Business Details Card
//                                       _buildEnhancedDetailsCard(businessProvider),
                                      
//                                       const SizedBox(height: 20),
                                      
//                                       // Business Hours Card
//                                       _buildEnhancedHoursCard(businessProvider),
                                      
//                                       const SizedBox(height: 20),
                                      
//                                       // Business Services Card
//                                       _buildEnhancedServicesCard(businessProvider),
                                      
//                                       const SizedBox(height: 24),
//                                     ] else ...[
//                                       _buildNoDataState(),
//                                     ],
//                                   ],
//                                 ),
//                               ),
//                             ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildEnhancedBusinessHeader(business) {
//     return Card(
//       margin: EdgeInsets.zero,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
//       color: Colors.white,
//       elevation: 2,
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 // Business Logo
//                 Container(
//                   width: 60,
//                   height: 60,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(12),
//                     color: const Color(0xFF4FC3F7).withOpacity(0.1),
//                   ),
//                   child: Icon(
//                     Icons.business_center,
//                     color: const Color(0xFF4FC3F7),
//                     size: 30,
//                   ),
//                 ),
                
//                 const SizedBox(width: 16),
                
//                 // Business Info
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         business.name,
//                         style: TextStyle(
//                           fontFamily: 'Poppins',
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: const Color(0xFF2C3E50),
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         business.businessType,
//                         style: TextStyle(
//                           fontFamily: 'Inter',
//                           fontSize: 14,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
                
//                 // Verification Badge
//                 if (business.isVerified)
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: Colors.green.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const Icon(
//                           Icons.verified_rounded,
//                           color: Colors.green,
//                           size: 16,
//                         ),
//                         const SizedBox(width: 4),
//                         Text(
//                           'Verified',
//                           style: TextStyle(
//                             fontFamily: 'Inter',
//                             fontSize: 12,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.green,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//               ],
//             ),
            
//             const SizedBox(height: 16),
            
//             // Rating and Status
//             Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: Colors.amber.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Icon(
//                         Icons.star_rounded,
//                         color: Colors.amber,
//                         size: 16,
//                       ),
//                       const SizedBox(width: 4),
//                       Text(
//                         business.rating.toStringAsFixed(1),
//                         style: TextStyle(
//                           fontFamily: 'Poppins',
//                           color: Colors.amber[700],
//                           fontWeight: FontWeight.bold,
//                           fontSize: 14,
//                         ),
//                       ),
//                       const SizedBox(width: 4),
//                       Text(
//                         '(${business.totalReviews})',
//                         style: TextStyle(
//                           fontFamily: 'Inter',
//                           color: Colors.grey[600],
//                           fontSize: 12,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
                
//                 const Spacer(),
                
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF4FC3F7).withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Container(
//                         width: 8,
//                         height: 8,
//                         decoration: BoxDecoration(
//                           color: business.isActive ? Colors.green : Colors.red,
//                           shape: BoxShape.circle,
//                         ),
//                       ),
//                       const SizedBox(width: 6),
//                       Text(
//                         business.isActive ? 'Active' : 'Inactive',
//                         style: TextStyle(
//                           fontFamily: 'Inter',
//                           color: const Color(0xFF4FC3F7),
//                           fontSize: 12,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildEnhancedDetailsCard(BusinessProvider businessProvider) {
//     return Card(
//       margin: EdgeInsets.zero,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
//       color: Colors.white,
//       elevation: 2,
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Business Details",
//               style: TextStyle(
//                 fontFamily: 'Poppins',
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: const Color(0xFF2C3E50),
//               ),
//             ),
//             const SizedBox(height: 16),
//             BusinessDetailsCard(
//               business: businessProvider.business!,
//               isEditing: businessProvider.isEditing,
//               onBusinessUpdated: (updatedBusiness) {
//                 businessProvider.updateBusinessInfo(updatedBusiness);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildEnhancedHoursCard(BusinessProvider businessProvider) {
//     return Card(
//       margin: EdgeInsets.zero,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
//       color: Colors.white,
//       elevation: 2,
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Business Hours",
//               style: TextStyle(
//                 fontFamily: 'Poppins',
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: const Color(0xFF2C3E50),
//               ),
//             ),
//             const SizedBox(height: 16),
//             BusinessHoursCard(
//               businessHours: businessProvider.business!.businessHours,
//               isEditing: businessProvider.isEditing,
//               onHoursUpdated: (updatedHours) {
//                 businessProvider.updateBusinessHours(updatedHours);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildEnhancedServicesCard(BusinessProvider businessProvider) {
//     return Card(
//       margin: EdgeInsets.zero,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
//       color: Colors.white,
//       elevation: 2,
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Services Offered",
//               style: TextStyle(
//                 fontFamily: 'Poppins',
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: const Color(0xFF2C3E50),
//               ),
//             ),
//             const SizedBox(height: 16),
//             BusinessServicesCard(
//               services: businessProvider.business!.services,
//               isEditing: businessProvider.isEditing,
//               onServicesUpdated: (updatedServices) {
//                 // Handle services update
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildNoDataState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const SizedBox(height: 100),
//           Icon(
//             Icons.business_outlined,
//             size: 80,
//             color: Colors.grey[400],
//           ),
//           const SizedBox(height: 16),
//           Text(
//             'No business information available',
//             style: TextStyle(
//               fontFamily: 'Poppins',
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//               color: Colors.grey[600],
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Set up your business profile to get started',
//             style: TextStyle(
//               fontFamily: 'Inter',
//               fontSize: 14,
//               color: Colors.grey[500],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _saveChanges() {
//     final businessProvider = Provider.of<BusinessProvider>(context, listen: false);
//     businessProvider.toggleEditMode();
    
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           'Changes saved successfully!',
//           style: TextStyle(
//             fontFamily: 'Inter',
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         backgroundColor: const Color(0xFF4FC3F7),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         duration: const Duration(seconds: 2),
//       ),
//     );
//   }
// }


// lib/views/business/business_info_screen.dart - UPDATED WITH APP COLORS & STYLES
import 'package:business_partner_main/resources/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/business_provider.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/error_widget.dart';
import '../../resources/colors/app_colors.dart'; 
import 'widgets/business_details_card.dart';
import 'widgets/business_hours_card.dart';
import 'widgets/business_services_card.dart';

class BusinessInfoScreen extends StatefulWidget {
  const BusinessInfoScreen({Key? key}) : super(key: key);

  @override
  State<BusinessInfoScreen> createState() => _BusinessInfoScreenState();
}

class _BusinessInfoScreenState extends State<BusinessInfoScreen> {
  @override
  void initState() {
    super.initState();
    _loadBusinessData();
  }

  void _loadBusinessData() {
    final businessProvider = Provider.of<BusinessProvider>(context, listen: false);
    businessProvider.loadBusinessData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, BusinessProvider>(
      builder: (context, authProvider, businessProvider, child) {
        return Scaffold(
          backgroundColor: AppColors.splashBackground,
          body: SafeArea(
            child: Column(
              children: [
                // HEADER WITH APP COLORS
                Container(
                  height: 65,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_rounded,
                          color: AppColors.splashPrimary,
                          size: 24,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const Spacer(),
                      Text(
                        'Business Information',
                        style: AppTextStyles.heading3.copyWith(fontSize: 20),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(
                          businessProvider.isEditing ? Icons.save_rounded : Icons.edit_rounded,
                          color: AppColors.splashPrimary,
                          size: 24,
                        ),
                        onPressed: () {
                          if (businessProvider.isEditing) {
                            _saveChanges();
                          } else {
                            businessProvider.toggleEditMode();
                          }
                        },
                      ),
                    ],
                  ),
                ),

                // MAIN CONTENT
                Expanded(
                  child: businessProvider.isLoading
                      ? const LoadingWidget(message: 'Loading business information...')
                      : businessProvider.errorMessage != null
                          ? CustomErrorWidget(
                              message: businessProvider.errorMessage!,
                              onRetry: _loadBusinessData,
                            )
                          : RefreshIndicator(
                              onRefresh: () async => _loadBusinessData(),
                              color: AppColors.splashPrimary,
                              child: SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (businessProvider.hasData) ...[
                                      // Business Header Card
                                      _buildBusinessHeader(businessProvider.business!),
                                      
                                      const SizedBox(height: 20),
                                      
                                      // Business Details Card
                                      _buildDetailsCard(businessProvider),
                                      
                                      const SizedBox(height: 20),
                                      
                                      // Business Hours Card
                                      _buildHoursCard(businessProvider),
                                      
                                      const SizedBox(height: 20),
                                      
                                      // Business Services Card
                                      _buildServicesCard(businessProvider),
                                      
                                      const SizedBox(height: 24),
                                    ] else ...[
                                      _buildNoDataState(),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBusinessHeader(business) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.backgroundGradient,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Business Logo
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [AppColors.splashPrimary, AppColors.splashSecondary],
                  ),
                ),
                child: Icon(
                  Icons.business_center,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Business Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      business.name,
                      style: AppTextStyles.heading3.copyWith(fontSize: 18),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      business.businessType,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.splashSubtext,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Verification Badge
              if (business.isVerified)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.verified_rounded,
                        color: Colors.green,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Verified',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Rating and Status
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: Colors.amber,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      business.rating.toStringAsFixed(1),
                      style: AppTextStyles.labelMedium.copyWith(
                        color: Colors.amber[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '(${business.totalReviews})',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.splashSubtext,
                      ),
                    ),
                  ],
                ),
              ),
              
              const Spacer(),
              
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.splashPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: business.isActive ? Colors.green : Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      business.isActive ? 'Active' : 'Inactive',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.splashPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard(BusinessProvider businessProvider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Business Details",
            style: AppTextStyles.labelLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.splashText,
            ),
          ),
          const SizedBox(height: 16),
          BusinessDetailsCard(
            business: businessProvider.business!,
            isEditing: businessProvider.isEditing,
            onBusinessUpdated: (updatedBusiness) {
              businessProvider.updateBusinessInfo(updatedBusiness);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHoursCard(BusinessProvider businessProvider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Business Hours",
            style: AppTextStyles.labelLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.splashText,
            ),
          ),
          const SizedBox(height: 16),
          BusinessHoursCard(
            businessHours: businessProvider.business!.businessHours,
            isEditing: businessProvider.isEditing,
            onHoursUpdated: (updatedHours) {
              businessProvider.updateBusinessHours(updatedHours);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildServicesCard(BusinessProvider businessProvider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Services Offered",
            style: AppTextStyles.labelLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.splashText,
            ),
          ),
          const SizedBox(height: 16),
          BusinessServicesCard(
            services: businessProvider.business!.services,
            isEditing: businessProvider.isEditing,
            onServicesUpdated: (updatedServices) {
              // Handle services update
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNoDataState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 100),
          Icon(
            Icons.business_outlined,
            size: 80,
            color: AppColors.splashSubtext,
          ),
          const SizedBox(height: 16),
          Text(
            'No business information available',
            style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.splashSubtext,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Set up your business profile to get started',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.splashSubtext,
            ),
          ),
        ],
      ),
    );
  }

  void _saveChanges() {
    final businessProvider = Provider.of<BusinessProvider>(context, listen: false);
    businessProvider.toggleEditMode();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Changes saved successfully!',
          style: AppTextStyles.bodyMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: AppColors.splashPrimary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
